# frozen_string_literal: true

class Room
  attr_reader :type_id
  attr_reader :type_name
  attr_reader :image_url
  attr_reader :area
  attr_reader :price
  attr_reader :non_smoking
  attr_reader :capacity
  attr_reader :vacant
  attr_reader :ota_url
  attr_reader :reservation_inquiry

  def initialize(json, params = nil, reservation_inquiry = nil)
    @params = params
    return if json.blank?
    @type_id = json['id']
    @type_name = json['name']
    @image_url = json['lineImage']&.to_s || "#{ENV['DOMAIN']}/images/no-image.png"
    @area = "#{json['roomArea'] || '-'}#{json['roomAreaUnit'] == 0 ? '平米' : '畳'}"
    @price = json['stockCalendar'].pluck('price')&.min&.to_s
    @non_smoking = json['labels'].first
    @capacity = "#{json['paxMin'] || '-'}〜#{json['paxMax'] || '-'}"
    @vacant = json['stockCalendar'].pluck('stock')&.min.to_i >= @params[:num_room].to_i
    @ota_url = json['otaUrl'] || ENV['DOMAIN']
    @reservation_inquiry = reservation_inquiry
  end

  def to_html
    content = (self.vacant ? FlexTemplate.rsv_available_template&.html_content : FlexTemplate.rsv_unavailable_template&.html_content)
    content = content.gsub(/{roomName}/, self.type_name)
    content = content.gsub(/{roomImageUrl}/, self.image_url)
    content = content.gsub(/{roomPrice}/, "#{self.price}円")
    content = content.gsub(/{roomArea}/, self.area)
    content = content.gsub(/{roomCapacity}/, "#{self.capacity}人")
    content = content.gsub(/{roomSmoking}/, self.non_smoking ? '禁煙' : '喫煙')
    content.gsub(/{roomOTAUrl}/, self.ota_url)
  end

  def normalized_json
    content = (self.vacant ? FlexTemplate.rsv_available_template&.content : FlexTemplate.rsv_unavailable_template&.content)
    content.extend Hashie::Extensions::DeepLocate
    # set room name
    rname_obj = (content.deep_locate -> (key, value, object) { key.eql?('text') && value.eql?('{roomName}') }).first
    rname_obj['text'] = self.type_name if rname_obj.present?
    # set room image
    rimage_obj = (content.deep_locate -> (key, value, object) { key.eql?('url') && value.eql?('{roomImageUrl}') }).first
    rimage_obj['url'] = self.image_url if rimage_obj.present?
    # set room price
    rprice_obj = (content.deep_locate -> (key, value, object) { key.eql?('text') && value.eql?('{roomPrice}') }).first
    rprice_obj['text'] = "#{self.price}円" if rprice_obj.present?
    # set room area
    rarea_obj = (content.deep_locate -> (key, value, object) { key.eql?('text') && value.eql?('{roomArea}') }).first
    rarea_obj['text'] = self.area if rarea_obj.present?
    # set room capacity
    rcap_obj = (content.deep_locate -> (key, value, object) { key.eql?('text') && value.eql?('{roomCapacity}') }).first
    rcap_obj['text'] = self.capacity.to_s + '人' if rcap_obj.present?
    # set room smoking allowance
    rsmoking_obj = (content.deep_locate -> (key, value, object) { key.eql?('text') && value.eql?('{roomSmoking}') }).first
    rsmoking_obj['text'] = self.non_smoking ? '禁煙' : '喫煙' if rsmoking_obj.present?

    if self.vacant
      # set room OTA
      rota_obj = (content.deep_locate -> (key, value, object) { key.eql?('uri') && value.eql?('{roomOTAUrl}') }).first
      rota_obj['uri'] = self.ota_url if rota_obj.present?
    else
      content = bind_postback_data(content)
    end
    content
  end

  private
    def bind_postback_data(content)
      postback_data = {
        actions: [{
          type: 'rsv_bookmark',
          content: {
            roomId: self.type_id,
            roomName: self.type_name,
            reservation_inquiry_id: self.reservation_inquiry&.id
          }
        }]
      }
      postback_action = (content.deep_locate -> (key, value, object) { key.eql?('type') && value.eql?('postback') }).first
      postback_action['data'] = postback_data if postback_action.present?
      content
    end
end
