# frozen_string_literal: true

class AvailableRoomNotificationJob < ReservationDispatcherJob
  private
    def find_channel
      @channel = @reservation&.line_friend&.channel
    end

    def get_rooms
      @rooms = parse_rooms_data([@params])
    end

    def build_content
      @rooms.first.normalized_json
    end

    def build_html_content
      content = @rooms.first.to_html

      html_sb = '<div class="d-flex">'
      html_sb += "<div class='reservation-item'>#{content}</div>"
      html_sb += '</div>'
      html_sb
    end
end
