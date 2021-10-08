# == Schema Information
#
# Table name: reminders
#
#  id         :bigint           not null, primary key
#  folder_id  :bigint
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reminders_on_folder_id  (folder_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#
FactoryBot.define do
  factory :reminder do
    
  end
end
