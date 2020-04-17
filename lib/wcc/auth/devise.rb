# frozen_string_literal: true

require 'wcc/auth'
require 'devise'

module WCC
  module Auth
    module Devise
      autoload :WatermarkCallbacksController,
               'wcc/auth/devise/watermark_callbacks_controller'
    end

    ConfiguresOAuth = lambda { |env|
      request = Rack::Request.new(env)

      env['omniauth.strategy'].options.merge!(
        client_id: WCC::Auth.config.app_id,
        client_secret: WCC::Auth.config.app_secret
      )
      env['omniauth.strategy'].options[:authorize_params].merge!(
        request.params['authorize_params'] || {}
      )
    }
  end
end

WCC::Auth.finalize_callbacks << lambda {
  require 'omniauth/strategies/watermark'

  Devise.setup do |config|
    config.omniauth :watermark, setup: WCC::Auth::ConfiguresOAuth
  end

  OmniAuth.config.full_host = WCC::Auth.config.app_url
}
