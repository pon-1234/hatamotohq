# frozen_string_literal: true

class ReservationInquiryJob < ApplicationJob
  queue_as :default

  def perform(params)
    friend_line_id = params[:friend_line_id]
    # room_capacity = params[:room_capacity]
    # date = params[:date]
    return if friend_line_id.blank?
    find_channel(friend_line_id)
    @rooms = parse_rooms_data(Pms::GetRoom.new.perform({}))
    # Send carousel message to show hotels info
    send_message
  end

  private
    def find_channel(line_id)
      friend = LineFriend.find_by(line_user_id: line_id)
      @channel = friend.channel
    end

    def parse_rooms_data(rooms_data)
      rooms = []
      rooms_data.each do |room_data|
        rooms << Room.new(room_data)
      end
      rooms
    end

    def send_message
      message = build_message
      payload = {
        channel_id: @channel.id,
        messages: [ message ]
      }
      PushMessageToLineJob.perform_now(payload)
    end

    def build_message
      {
        type: 'flex',
        altText: '予約用のメッセージ',
        contents: build_content,
        html_content: build_html_content
      }
    end

    def build_content
      contents = []
      @rooms.each do |room|
        contents << room.normalized_json
      end
      {
        type: 'carousel',
        contents: contents
      }
    end

    def build_html_content
      contents = []
      @rooms.each do |room|
        contents << room.to_html
      end

      html_sb = '<div class="d-flex">'
      contents.each do |content|
        html_sb += "<div class='reservation-item'>#{content}</div>"
      end
      html_sb += '</div>'
      html_sb
    end
end
