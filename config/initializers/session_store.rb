# frozen_string_literal: true

# if Rails.env.production?
#   Rails.application.config.session_store :cache_store, key: "_lineinsight_session_#{Rails.env}", expire_after: 1.months, secure: true, httponly: true, same_site: :lax
# else
Rails.application.config.session_store :cookie_store, key: "_lineinsight_session_#{Rails.env}", expire_after: 1.months, secure: false, httponly: true, same_site: :lax
# end
