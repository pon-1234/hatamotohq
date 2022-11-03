# frozen_string_literal: true

class AvailableRoomNotificationJob < ReservationDispatcherJob
  def perform(params, reservation = nil)
    @params = params
    @reservation = reservation
    find_channel
    get_rooms
    send_text_message('The room you want to book is available, please check detail below')
    send_message
    # Mark reservation as done
    # reservation.update(status: :done)
  end

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
