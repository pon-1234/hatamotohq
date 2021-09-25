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
#  action          :text(4294967295)
#  success_message :text(65535)
#  status          :string(255)      default("enabled")
#  is_publish      :boolean          default(FALSE)
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
  belongs_to :folder

  validates :name, presence: true, length: { maximum: 255 }
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true
end
