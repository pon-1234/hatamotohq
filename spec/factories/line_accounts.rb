# frozen_string_literal: true

# == Schema Information
#
# Table name: line_accounts
#
#  id              :bigint           not null, primary key
#  client_id       :bigint
#  line_user_id    :string(255)
#  line_name       :string(255)
#  display_name    :string(255)
#  channel_id      :string(255)
#  channel_secret  :string(255)
#  invite_url      :string(255)
#  webhook_url     :string(255)
#  liff_id         :string(255)
#  note            :text(65535)
#  bot_initialized :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
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
