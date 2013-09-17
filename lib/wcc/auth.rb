require "wcc/auth/version"
require "wcc/auth/config"

require "omniauth"
require "omniauth-oauth2"

module WCC
  module Auth

    def self.setup
      yield config
      finalize
    end

    def self.config
      @config ||= WCC::Auth::Config.new
    end

    def self.finalize
      finalize_callbacks.each(&:call)
    end

    def self.finalize_callbacks
      @finalize_callbacks ||= []
    end

  end
end
