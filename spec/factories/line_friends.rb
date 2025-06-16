# frozen_string_literal: true

# == Schema Information
#
# Table name: line_friends
#
#  id               :bigint           not null, primary key
#  line_account_id  :bigint
#  line_picture_url :string
#  line_user_id     :string
#  line_name        :string
#  display_name     :string
#  status           :string           default("active")
#  note             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deleted_at       :datetime
#  locked           :boolean          default(FALSE)
#  visible          :boolean          default(TRUE)
#  tester           :boolean          default(FALSE)
#  stream_route_id  :bigint
#
# Indexes
#
#  index_line_friends_on_line_account_id  (line_account_id)
#  index_line_friends_on_stream_route_id  (stream_route_id)
#  index_line_friends_on_tester           (tester)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (stream_route_id => stream_routes.id)
#
FactoryBot.define do
  factory :line_friend do
    line_user_id { '12sdafsqweeqzcsadvb' }
    line_name { 'sample name' }
    display_name { 'sample name' }
    status { 'active' }
    visible { true }
  end
end
