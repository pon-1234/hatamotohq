# frozen_string_literal: true

class Pms::CreateRoomNotifier < Pms::BaseRequest
  def perform(room_type_id, room_condition_info)
    options = {
      headers: auth_header.merge('Content-Type' => 'application/json', 'accept' => 'application/json'),
      body: room_condition_info.to_json
    }
    response = self.class.post("/roomtypes/#{room_type_id}/notifier", options)
    return nil if response.code != 200
    jsonBody = JSON.parse(response.body)
    jsonBody['notifierId']
  rescue
    nil
  end
end
