require "wcc/auth"
require "devise"

WCC::Auth.finalize_callbacks << -> {
  require "omniauth/strategies/watermark"
  Devise.setup do |config|
    config.omniauth :watermark, WCC::Auth.config.app_id, WCC::Auth.config.app_secret
  end
}

