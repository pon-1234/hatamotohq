# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id             :bigint           not null, primary key
#  url            :text
#  name           :string
#  folder_id      :bigint           not null
#  sending_count  :integer          default(0)
#  click_count    :integer          default(0)
#  receiver_count :integer          default(0)
#  visitor_count  :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  client_id      :bigint           not null
#
# Indexes
#
#  index_sites_on_client_id  (client_id)
#  index_sites_on_folder_id  (folder_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (folder_id => folders.id)
#
FactoryBot.define do
  factory :site do
    url { 'MyText' }
    name { 'MyString' }
    folder { nil }
    sending_count { 1 }
    click_count_integer { 'MyString' }
    receiver_count { 1 }
    visitor_count { 1 }
    code { 'MyString' }
  end
end
