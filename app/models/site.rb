# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id                  :bigint           not null, primary key
#  url                 :text(65535)
#  name                :string(255)
#  folder_id           :bigint           not null
#  sending_count       :integer
#  click_count_integer :string(255)
#  receiver_count      :integer
#  visitor_count       :integer
#  code                :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_sites_on_code       (code)
#  index_sites_on_folder_id  (folder_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#
class Site < ApplicationRecord
  belongs_to :folder
  validates :code, presence: true, uniqueness: true
end
