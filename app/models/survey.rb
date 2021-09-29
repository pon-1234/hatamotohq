# frozen_string_literal: true

# == Schema Information
#
# Table name: surveys
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  folder_id       :bigint
#  code            :string(255)
#  name            :string(255)
#  liff_id         :string(255)
#  title           :string(255)
#  description     :text(65535)
#  after_action    :json
#  success_message :text(65535)
#  status          :string(255)      default(NULL)
#  re_answer       :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
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
class Survey < ApplicationRecord
  default_scope { order(created_at: :desc) }
  belongs_to :line_account
  belongs_to :folder
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
  after_create_commit :exec_after_create_commit

  private
    def exec_after_create_commit
    end

    def generate_code
      loop do
        code = Devise.friendly_token(10)
        break code unless Survey.where(code: code).first
      end
    end
end
