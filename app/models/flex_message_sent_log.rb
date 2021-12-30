# frozen_string_literal: true

# == Schema Information
#
# Table name: flex_message_sent_logs
#
#  id              :bigint           not null, primary key
#  html_template   :text(4294967295)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  flex_message_id :bigint
#  line_account_id :bigint
#
# Indexes
#
#  index_flex_message_sent_logs_on_flex_message_id  (flex_message_id)
#  index_flex_message_sent_logs_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (flex_message_id => flex_messages.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class FlexMessageSentLog < ApplicationRecord
end
