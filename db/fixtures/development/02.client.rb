# frozen_string_literal: true

Client.seed do |s|
  s.id = 1
  s.agency = Agency.first
  s.name = 'ホテル１'
  s.address = '東京'
  s.phone_number = '0123456789'
end
