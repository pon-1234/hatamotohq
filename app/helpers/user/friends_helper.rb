# frozen_string_literal: true

module User::FriendsHelper
  include CsvHelper

  def line_friends_for_export(friends)
    rows = []
    headers = %w(id line_user_id line_name display_name line_picture_url status note created_at)
    friends.each do |friend|
      rows << to_row(headers, friend)
    end
    rows
  end

  def to_row(headers, friend)
    row = {}
    headers.each do |header|
      row[header] = friend[header]
    end
    row['tags'] = friend.tags.collect(&:name).join('、')
    row
  end
end
