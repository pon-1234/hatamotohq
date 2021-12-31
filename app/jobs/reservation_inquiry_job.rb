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
          area: 25,
          capacity: 2,
          smoking: false,
          vacant: false
        },
        {
          id: 1,
          name: 'VIP',
          price: 10000,
          image_url: 'https://scdn.line-apps.com/n/channel_devcenter/img/flexsnapshot/clip/clip3.jpg',
          ota_url: 'https://www.agoda.com/apartments/',
          area: 25,
          capacity: 1,
          smoking: true,
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
      # set room area
      rarea_obj = (content.deep_locate -> (key, value, object) { key.eql?('text') && value.eql?('{roomArea}') }).first
      rarea_obj['text'] = room[:area].to_s + 'm²' if rarea_obj.present?
      # set room capacity
      rcap_obj = (content.deep_locate -> (key, value, object) { key.eql?('text') && value.eql?('{roomCapacity}') }).first
      rcap_obj['text'] = room[:capacity].to_s + '人' if rcap_obj.present?
      # set room smoking allowance
      rsmoking_obj = (content.deep_locate -> (key, value, object) { key.eql?('text') && value.eql?('{roomSmoking}') }).first
      rsmoking_obj['text'] = room[:smoking] ? '喫煙' : '禁煙'

      if room[:vacant]
        # set room OTA
        rota_obj = (content.deep_locate -> (key, value, object) { key.eql?('uri') && value.eql?('{roomOTAUrl}') }).first
        rota_obj['uri'] = room[:ota_url].to_s if rota_obj.present?
      else
        content = bind_postback_data(content)
      end
      content
    end

    def bind_postback_data(content)
      postback_data = {
        actions: [{
          type: 'rsv_bookmark',
          content: {
            roomId: 1 # TODO roomId
          }
        }]
      }
      postback_action = (content.deep_locate -> (key, value, object) { key.eql?('type') && value.eql?('postback') }).first
      postback_action['data'] = postback_data if postback_action.present?
      content
    end
end
