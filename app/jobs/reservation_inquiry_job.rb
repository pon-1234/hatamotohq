# frozen_string_literal: true

class ReservationInquiryJob < ApplicationJob
  queue_as :default

  def perform(params)
    friend_line_id = params[:friend_line_id]
    name = params[:name]
    phone_number = params[:phone_number]
    date = params[:date]
    return if friend_line_id.blank?
    find_channel(friend_line_id)
    # TODO call api to hotel insight pms
    # Send carousel message to show hotels info
    send_message
  end

  private
    def find_channel(line_id)
      friend = LineFriend.find_by(line_user_id: line_id)
      @channel = friend.channel
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
        altText: 'this is a flex message for reservation',
        contents: build_content
      }
    end

    def build_content
      rooms = [
        {
          id: 1,
          name: 'KING',
          price: 20000,
          image_url: 'https://scdn.line-apps.com/n/channel_devcenter/img/flexsnapshot/clip/clip3.jpg',
          vacant: false
        },
        {
          id: 1,
          name: 'VIP',
          price: 10000,
          image_url: 'https://scdn.line-apps.com/n/channel_devcenter/img/flexsnapshot/clip/clip3.jpg',
          vacant: true
        }
      ]

      contents = []
      rooms.each do |room|
        contents << build_room_content(room)
      end

      {
        type: 'carousel',
        contents: contents
      }
    end

    def build_room_content(room)
      content = (room[:vacant] ? FlexTemplate.rsv_available_content : FlexTemplate.rsv_unavailable_content).to_json
      content = content.gsub(/{roomName}/, room[:name].to_s)
      content = content.gsub(/{roomImageUrl}/, room[:image_url].to_s)
      content = content.gsub(/{roomPrice}/, room[:price].to_s)
      if room[:vacant]
        content = bind_room_ota_url(content)
      else
        content = bind_postback_data(content)
      end

      JSON.parse(content)
    end

    def bind_postback_data(content)
      postback_data = {
        type: 'postback'
      }
      # byebug
      content.gsub(/{postbackData}/, postback_data)
    end

    def bind_room_ota_url(content)
      content.gsub(/{roomOTAUrl}/, 'https://google.com')
    end
end
