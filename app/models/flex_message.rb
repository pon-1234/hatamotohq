# frozen_string_literal: true

# == Schema Information
#
# Table name: flex_messages
#
#  id              :bigint           not null, primary key
#  deleted_at      :datetime
#  html_template   :text(4294967295)
#  json_message    :json
#  json_template   :json
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  line_account_id :bigint
#
# Indexes
#
#  index_flex_messages_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class FlexMessage < ApplicationRecord
end
