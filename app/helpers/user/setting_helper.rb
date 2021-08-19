module User::SettingHelper
  def line_account_setting_as_json(line_account)
    line_account.as_json(only: [
      :line_name,
      :display_name,
      :line_channel_id,
      :line_channel_secret,
      :webhook_url,
      :liff_id
    ])
  end
end
