# frozen_string_literal: true

# == Schema Information
#
# Table name: surveys
#
#  id               :bigint           not null, primary key
#  action           :text(4294967295)
#  code             :string(255)
#  deleted_at       :datetime
#  description      :text(65535)
#  is_publish       :boolean          default(FALSE)
#  multiple_answers :boolean          default(FALSE)
#  name             :string(255)
#  status           :string(255)      default("enabled")
#  success_message  :text(65535)
#  title            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  folder_id        :bigint
#  liff_id          :string(255)
#  line_account_id  :bigint
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
end
