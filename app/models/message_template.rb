# frozen_string_literal: true

# == Schema Information
#
# Table name: message_templates
#
#  id              :bigint           not null, primary key
#  content         :text(4294967295)
#  deleted_at      :datetime
#  message_type    :string(255)
#  title           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  folder_id       :bigint
#  line_account_id :bigint
#
# Indexes
#
#  index_message_templates_on_folder_id        (folder_id)
#  index_message_templates_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class MessageTemplate < ApplicationRecord
end
