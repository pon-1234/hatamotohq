# frozen_string_literal: true

# == Schema Information
#
# Table name: surveys
#
#  id                :bigint           not null, primary key
#  line_account_id   :bigint
#  folder_id         :bigint
#  code              :string(255)
#  name              :string(255)
#  banner_url        :string(255)
#  liff_id           :string(255)
#  title             :string(255)
#  description       :text(65535)
#  after_action      :json
#  success_message   :text(65535)
#  status            :string(255)      default(NULL)
#  re_answer         :boolean          default(FALSE)
#  ggapi_auth_code   :string(255)
#  ggapi_auth_tokens :json
#  spreadsheet_id    :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  deleted_at        :datetime
#
# Indexes
#
#  index_surveys_on_folder_id        (folder_id)
#  index_surveys_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#

require 'google/apis/sheets_v4'

class Survey < ApplicationRecord
  default_scope { order(created_at: :desc) }
  belongs_to :line_account
  belongs_to :folder
  has_many :survey_responses
  has_many :survey_questions, dependent: :destroy
  accepts_nested_attributes_for :survey_questions, allow_destroy: true

  # Validation
  validates :name, presence: true, length: { maximum: 255 }
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true

  # Scope
  enum status: { published: 'published', unpublished: 'unpublished', draft: 'draft' }

  before_create do
    self.code = generate_code
  end

  before_save :get_google_service_tokens, if: :will_save_change_to_ggapi_auth_code?

  def destroyable?
    self.survey_responses.count == 0
  end

  def responses_count
    survey_responses.count
  end

  def users_count
    survey_responses.pluck(:line_friend_id).uniq.size
  end

  def answered_users
    LineFriend.distinct.joins(:survey_responses)
      .references(:survey_responses)
      .where('survey_responses.line_friend_id = line_friends.id AND survey_responses.survey_id = ?', self.id)
  end

  def responses
    self.survey_responses.includes([:line_friend, survey_answers: [:survey_question, file_attachment: [:blob]]])
  end

  def responses_by(friend_id)
    self.survey_responses.where('survey_responses.line_friend_id = ?', friend_id).includes([:line_friend, survey_answers: [:survey_question, file_attachment: [:blob]]])
  end

  def clone!
    new_survey = self.dup
    new_survey.name = self.name + '（コピー）'
    new_survey.status = :draft
    new_survey.save!
    self.survey_questions&.each { |question| question.clone_to!(new_survey.id) }
    new_survey
  end

  def toggle_status
    self.status = self.published? ? 'unpublished' : 'published'
    self.save
  end

  def get_google_service_tokens
    return if self.ggapi_auth_code.nil?
    result = GoogleApi::GetServiceTokens.new.perform(self.ggapi_auth_code)
    self.ggapi_auth_tokens = result

    create_survey_sheet
  end

  def create_survey_sheet
    return if self.spreadsheet_id.nil?
    sheets = Google::Apis::SheetsV4::SheetsService.new
    sheets.authorization = self.ggapi_auth_tokens['access_token']
    spreadsheet = {
      properties: {
        title: self.name
      }
    }
    spreadsheet = sheets.create_spreadsheet(spreadsheet,
                                            fields: 'spreadsheetId')
    self.spreadsheet_id = spreadsheet.spreadsheet_id

    # Add sheet header
    question_titles = survey_questions.pluck('content').pluck('text')
    values = [
      [
        '回答ID',
        '回答日時',
        '回答者ID',
        '回答者名'
      ] + question_titles
    ]
    value_range = Google::Apis::SheetsV4::ValueRange.new(values: values)
    result = sheets.append_spreadsheet_value(self.spreadsheet_id,
                                              "A1:A#{4 + question_titles.size}",
                                              value_range,
                                              value_input_option: 'RAW')
  end

  private
    def generate_code
      loop do
        code = Devise.friendly_token(10)
        break code unless Survey.where(code: code).first
      end
    end
end
