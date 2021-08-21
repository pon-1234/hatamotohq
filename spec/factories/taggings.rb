# == Schema Information
#
# Table name: taggings
#
#  id            :bigint           not null, primary key
#  deleted_at    :datetime
#  taggable_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tag_id        :bigint
#  taggable_id   :bigint
#
# Indexes
#
#  index_taggings_on_tag_id                         (tag_id)
#  index_taggings_on_taggable_type_and_taggable_id  (taggable_type,taggable_id)
#
# Foreign Keys
#
#  fk_rails_...  (tag_id => tags.id)
#
FactoryBot.define do
  factory :tagging do
    
  end
end
