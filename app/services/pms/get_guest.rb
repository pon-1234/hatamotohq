# frozen_string_literal: true

class Pms::GetGuest < Pms::BaseRequest
  def perform(line_id)
    response = self.class.get("/guests/#{line_id}", headers: auth_header) rescue nil
  end
end
