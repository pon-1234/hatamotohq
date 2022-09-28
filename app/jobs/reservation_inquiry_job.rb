# frozen_string_literal: true

class ReservationInquiryJob < ReservationDispatcherJob
  def perform(params)
    return if params[:friend_line_id].blank?
    @inquiry = ReservationInquiry.create!(num_room: params[:num_room], date_start: (Date.parse(params[:date_start]) rescue nil),
      date_end: (Date.parse(params[:date_end]) rescue nil))
    super(params)
  end

  private
    def find_channel
      friend = LineFriend.find_by line_user_id: @params[:friend_line_id]
      @channel = friend.channel
    end

    def get_rooms
      @rooms = parse_rooms_data(Pms::GetRoom.new(@channel.line_account.pms_api_key).perform({ num_room: @params[:num_room], check_in: @params[:date_start], check_out: @params[:date_end] }))
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
