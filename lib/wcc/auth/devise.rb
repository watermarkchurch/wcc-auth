# frozen_string_literal: true

require 'wcc/auth'
require 'devise'

module WCC
  module Auth
    module Devise
      autoload :WatermarkCallbacksController,
               'wcc/auth/devise/watermark_callbacks_controller'
    end

    SetupOAuth = lambda { |env|
      request = Rack::Request.new(env)

      env['omniauth.strategy'].options[:client_id] = config.app_id
      env['omniauth.strategy'].options[:client_secret] = config.app_secret
      auth_params = config.authorize_params.merge(
        request.params['authorize_params'] || {}
      )

      auth_params.each do |k, v|
        env['omniauth.strategy'].options[:authorize_params][k] = v
      end
    }
  end
end

WCC::Auth.finalize_callbacks << lambda {
  require 'omniauth/strategies/watermark'

  Devise.setup do |config|
    config.omniauth :watermark, setup: WCC::Auth::SetupOAuth
  end

  OmniAuth.config.full_host = WCC::Auth.config.app_url
}
