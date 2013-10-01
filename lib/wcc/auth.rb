require "wcc/auth/version"
require "wcc/auth/config"

require "wcc/auth/access_level"
require "wcc/auth/ability"
require "wcc/auth/providers"
require "wcc/auth/controller_helpers"

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
