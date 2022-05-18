# frozen_string_literal: true

# == Schema Information
#
# Table name: stream_routes
#
#  id                     :bigint           not null, primary key
#  folder_id              :bigint           not null
#  name                   :string(255)
#  actions                :json
#  code                   :string(255)
#  run_add_friend_actions :boolean          default(FALSE)
#  always_run_actions     :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_stream_routes_on_folder_id  (folder_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#
FactoryBot.define do
  factory :stream_route do
    folder { nil }
    name { 'MyString' }
    actions { '' }
    code { 'MyString' }
    run_add_friend_actions { false }
    always_run_actions { false }
  end
end
