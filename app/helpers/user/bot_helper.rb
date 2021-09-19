# frozen_string_literal: true

module User::BotHelper
  def valid_bot?(channel_id, channel_secret)
    config = {
      channel_id: channel_id,
      channel_secret: channel_secret
    }
    LineApi::BaseRequest.new(config).channel_token.present?
  end
end
