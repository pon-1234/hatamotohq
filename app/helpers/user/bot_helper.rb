# frozen_string_literal: true

module User::BotHelper
  def valid_bot?(channel_id, channel_secret)
    LineApi::BaseRequest.new(channel_id, channel_secret).access_token.present?
  end
end
