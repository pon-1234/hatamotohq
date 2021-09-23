# frozen_string_literal: true

# == Schema Information
#
# Table name: auto_responses
#
#  id              :bigint           not null, primary key
#  deleted_at      :datetime
#  keyword         :string(255)
#  keyword_status  :string(255)
#  name            :string(255)
#  status          :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  folder_id       :bigint
#  line_account_id :bigint
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
end
