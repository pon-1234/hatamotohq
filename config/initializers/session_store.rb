# frozen_string_literal: true

if Rails.env.production?
  Rails.application.config.session_store :cookie_store,
    key: "_lineinsight_session_production",
    domain: :all,
    expire_after: 1.months,
    secure: true,
    httponly: true,
    same_site: :lax
else
  # 開発環境用の設定
  # secure, httponly, same_site は development.rb の設定に任せる
  Rails.application.config.session_store :cookie_store,
    key: "_lineinsight_session_development",
    domain: :all,
    tld_length: 2,
    expire_after: 1.months
end
