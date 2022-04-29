# frozen_string_literal: true

# == Schema Information
#
# Table name: sites_line_friends
#
#  id             :bigint           not null, primary key
#  site_id        :bigint           not null
#  line_friend_id :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sent           :boolean          default(FALSE)
#  visited        :boolean          default(FALSE)
#
# Indexes
#
#  index_sites_line_friends_on_line_friend_id  (line_friend_id)
#  index_sites_line_friends_on_site_id         (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_friend_id => line_friends.id)
#  fk_rails_...  (site_id => sites.id)
#
class SitesLineFriend < ApplicationRecord
  belongs_to :site
  belongs_to :line_friend
end
