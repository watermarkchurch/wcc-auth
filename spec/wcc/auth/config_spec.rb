require 'spec_helper'

describe WCC::Auth::Config do
  let(:klass) { WCC::Auth::Config }

  describe "default attributes" do
    subject { klass.new }
    it "sets authorize_site according to environment" do
      subject.environment = :development
      expect(subject.authorize_site).to eq("http://login.dev")
      subject.environment = :production
      expect(subject.authorize_site).to eq("https://login.watermark.org")
    end

    it "sets authorize_path" do
      expect(subject.authorize_path).to eq("/oauth/authorize")
    end
  end


end
