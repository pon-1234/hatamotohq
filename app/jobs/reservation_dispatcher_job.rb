# frozen_string_literal: true

class ReservationDispatcherJob < ApplicationJob
  queue_as :default

  def perform(params, reservation = nil)
    @params = params
    @reservation = reservation
    find_channel
    get_rooms
    send_message
  end

  private
    def find_channel; end
    def get_rooms; end

    def parse_rooms_data(rooms_data)
      rooms = []
      rooms_data.each do |room_data|
        rooms << Room.new(room_data, @inquiry)
      end
      rooms
    end

    def send_message
      if @rooms.blank?
        send_text_message('空室がございませんでした、しばらくしてもう一度お試しください。')
      else
        message = build_message
        payload = {
          channel_id: @channel.id,
          messages: [ message ]
        }
        PushMessageToLineJob.perform_now(payload)
      end
    end

    def build_message
      {
        type: 'flex',
        altText: '予約用のメッセージ',
        contents: build_content,
        html_content: build_html_content
      }
    end

    def send_text_message(text)
      messages = [{ type: 'text', text: text }]
      # Rebuild payload
      payload = {
        channel_id: @channel.id,
        messages: messages
      }
      PushMessageToLineJob.perform_later(payload)
    end
end
