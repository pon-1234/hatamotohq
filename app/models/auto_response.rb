# frozen_string_literal: true

# == Schema Information
#
# Table name: auto_responses
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  folder_id       :bigint
#  name            :string(255)
#  status          :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
#  hit_count       :integer          default(0)
#
# Indexes
#
#  index_auto_responses_on_folder_id        (folder_id)
#  index_auto_responses_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class AutoResponse < ApplicationRecord
  belongs_to :line_account
  belongs_to :folder
  has_many :auto_response_keywords, dependent: :destroy
  has_many :auto_response_messages, dependent: :destroy

  enum status: { enabled: 'enabled', disabled: 'disabled' }

  def increase_hit_count
    self.hit_count += 1
    self.save
  end

  def clone!
    new_auto_response = self.dup
    new_auto_response.name = self.name + '（コピー）'
    new_auto_response.status = :disabled
    new_auto_response.save!
    self.auto_response_messages&.each { |message| message.clone_to!(new_auto_response.id) }
    self.auto_response_keywords&.each { |keyword| keyword.clone_to!(new_auto_response.id) }
    new_auto_response
  end
end
