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
          ota_url: 'https://www.agoda.com/apartments/',
          vacant: false
        },
        {
          id: 1,
          name: 'VIP',
          price: 10000,
          image_url: 'https://scdn.line-apps.com/n/channel_devcenter/img/flexsnapshot/clip/clip3.jpg',
          ota_url: 'https://www.agoda.com/apartments/',
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
      content = (room[:vacant] ? FlexTemplate.rsv_available_content : FlexTemplate.rsv_unavailable_content)
      content.extend Hashie::Extensions::DeepLocate
      # set room name
      rname_obj = (content.deep_locate -> (key, value, object) { key.eql?('text') && value.eql?('{roomName}') }).first
      rname_obj['text'] = room[:name].to_s if rname_obj.present?
      # set room image
      rimage_obj = (content.deep_locate -> (key, value, object) { key.eql?('url') && value.eql?('{roomImageUrl}') }).first
      rimage_obj['url'] = room[:image_url].to_s if rimage_obj.present?
      # set room price
      rprice_obj = (content.deep_locate -> (key, value, object) { key.eql?('text') && value.eql?('{roomPrice}') }).first
      rprice_obj['text'] = room[:price].to_s + ' 円' if rprice_obj.present?

      if room[:vacant]
        # set room OTA
        rota_obj = (content.deep_locate -> (key, value, object) { key.eql?('url') && value.eql?('{roomOTAUrl}') }).first
        rota_obj['url'] = room[:ota_url].to_s if rota_obj.present?
      else
        content = bind_postback_data(content)
      end
    end

    def bind_postback_data(content)
      postback_data = {
        actions: [{
          type: 'rsv_bookmarked',
          content: {
            id: 1 # TODO roomId
          }
        }]
      }
      postback_action = (content.deep_locate -> (key, value, object) { key.eql?('type') && value.eql?('postback') }).first
      postback_action['data'] = postback_data
      content
    end
end
