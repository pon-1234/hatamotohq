# frozen_string_literal: true

module User::SettingHelper
  def line_account_setting_as_json(line_account)
    line_account.as_json(only: [
      :line_name,
      :display_name,
      :channel_id,
      :channel_secret,
      :webhook_url,
      :liff_id
    ])
  end
end
