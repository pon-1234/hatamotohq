# frozen_string_literal: true

# == Schema Information
#
# Table name: line_accounts
#
#  id              :bigint           not null, primary key
#  line_user_id    :string
#  line_name       :string
#  display_name    :string
#  channel_id      :string
#  channel_secret  :string
#  invite_url      :string
#  webhook_url     :string
#  liff_id         :string
#  note            :text
#  bot_initialized :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
#  client_id       :bigint
#  pms_api_key     :string
#
# Indexes
#
#  index_line_accounts_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
FactoryBot.define do
  factory :line_account do
    line_user_id { '12sdafsqweeqzcsadvb' }
    line_name { 'sample name' }
    display_name { 'sample name' }
    channel_id { 'qwefgadas2322' }
    channel_secret { '132adaswqewqcz' }
    webhook_url { 'http://localhost/webhook/13423423dasd' }
    bot_initialized { true }
  end
end
