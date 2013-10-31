require "wcc/auth"
require "devise"

module WCC
  module Auth
    module Devise
      autoload :WatermarkCallbacksController, 'wcc/auth/devise/watermark_callbacks_controller'
    end
  end
end

WCC::Auth.finalize_callbacks << -> {
  require "omniauth/strategies/watermark"
  Devise.setup do |config|
    config.omniauth :watermark,
      WCC::Auth.config.app_id,
      WCC::Auth.config.app_secret
  end

  OmniAuth.config.full_host = WCC::Auth.config.app_url
}

