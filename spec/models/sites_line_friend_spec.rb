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
require 'rails_helper'

RSpec.describe SitesLineFriend, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
