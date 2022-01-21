# frozen_string_literal: true

# == Schema Information
#
# Table name: line_friends
#
#  id               :bigint           not null, primary key
#  line_account_id  :bigint
#  line_picture_url :string(255)
#  line_user_id     :string(255)
#  line_name        :string(255)
#  display_name     :string(255)
#  status           :string(255)      default("active")
#  locked           :boolean          default(FALSE)
#  visible          :boolean          default(TRUE)
#  note             :text(65535)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deleted_at       :datetime
#  tester           :boolean          default(FALSE)
#
# Indexes
#
#  index_line_friends_on_line_account_id  (line_account_id)
#  index_line_friends_on_tester           (tester)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
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
