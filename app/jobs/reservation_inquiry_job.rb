# frozen_string_literal: true

class ReservationInquiryJob < ReservationDispatcherJob
  def perform(params)
    return if params[:friend_line_id].blank?
    @inquiry = ReservationInquiry.create!(capacity: params[:capacity], start_date: (Date.parse(params[:dateStart]) rescue nil),
      end_date: (Date.parse(params[:dateEnd]) rescue nil))
    super(params)
  end

  private
    def find_channel
      friend = LineFriend.find_by line_user_id: @params[:friend_line_id]
      @channel = friend.channel
    end

    def get_rooms
      @rooms = parse_rooms_data(Pms::GetRoom.new.perform({ pax: @params[:capacity], dateStart: @params[:dateStart], dateEnd: @params[:dateEnd] }))
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
