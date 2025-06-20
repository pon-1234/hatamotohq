# frozen_string_literal: true

# == Schema Information
#
# Table name: channels
#
#  id               :bigint           not null, primary key
#  line_account_id  :bigint
#  line_friend_id   :bigint
#  title            :string
#  avatar           :string
#  last_message     :string
#  alias            :string
#  slug             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deleted_at       :datetime
#  last_activity_at :datetime
#  last_seen_at     :datetime
#  locked           :boolean
#  assignee_id      :bigint
#
# Indexes
#
#  index_channels_on_assignee_id      (assignee_id)
#  index_channels_on_line_account_id  (line_account_id)
#  index_channels_on_line_friend_id   (line_friend_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignee_id => users.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (line_friend_id => line_friends.id)
#
FactoryBot.define do
  factory :channel do
    title { 'sample title' }
    last_message { 'hello' }
    last_activity_at { 1.hour.ago }
    last_seen_at { 5.minutes.ago }
    locked { false }
  end
end
