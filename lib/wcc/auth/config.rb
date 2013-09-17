WCC::Auth::Config = Struct.new(:environment,
                               :app_id,
                               :app_secret,
                               :provider,
                               :authorize_path) do

  def environment
    self[:environment] || :development
  end

  def provider
    self[:provider] || default_provider
  end

  def authorize_path
    self[:authorize_path] || "/oauth/authorize"
  end

  private

  def default_provider
    case environment
    when :development
      "http://nucleus.dev"
    when :production
      "http://login.watermark.org"
    end
  end

end
