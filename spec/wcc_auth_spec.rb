require 'spec_helper'

describe WCC::Auth do

  before(:each) do
    @previous_config = WCC::Auth.send(:instance_variable_get, :@config)
    @previous_callbacks = WCC::Auth.send(:instance_variable_get, :@finalize_callbacks)
  end

  after(:each) do
    WCC::Auth.send :instance_variable_set, :@config, @previous_config
    WCC::Auth.send :instance_variable_set, :@finalize_callbacks, @previous_callbacks
  end

  describe "::setup class method" do
    it "yields config with ::setup and sets it to ::config" do
      the_config = nil
      WCC::Auth.setup do |config|
        expect(config).to be_a(WCC::Auth::Config)
        the_config = config
      end
      expect(the_config).to eq(WCC::Auth.config)
    end

    it "calls finalize" do
      ping = nil
      WCC::Auth.finalize_callbacks << -> { ping = "pong" }
      WCC::Auth.setup { |config| }
      expect(ping).to eq("pong")
    end
  end

end
