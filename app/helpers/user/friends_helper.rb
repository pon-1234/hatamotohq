# frozen_string_literal: true

module User::FriendsHelper
  include CsvHelper

  def line_friends_for_export(friends)
    rows = []
    headers = %w(id line_user_id line_name display_name line_picture_url status note created_at)
    friends.each do |friend|
      row = export_for_row_hash(headers, friend)
      row['tags'] = friend.tags.pluck(:name).join(',')
      rows << row
    end
    rows
  end
end
