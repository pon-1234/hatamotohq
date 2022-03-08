# frozen_string_literal: true

module User::FriendsHelper
  def line_friends_for_export(friends)
    rows = []
    friends.each do |friend|
      rows << {
        'id' => friend.id,
        'line_user_id' => friend.line_user_id,
        'line_name' => friend.line_name,
        'display_name' => friend.display_name,
        'line_picture_url' => friend.line_picture_url,
        'tags' => friend.tags.pluck(:name).join(','),
        'status' => friend.status,
        'note' => friend.note,
        'created_at' => friend.created_at
      }
    end
    rows
  end
end
