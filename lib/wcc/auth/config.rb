WCC::Auth::Config = Struct.new(:environment,
                               :app_id,
                               :app_secret,
                               :authorize_site,
                               :authorize_path) do

  def authorize_site
    self[:authorize_site] || default_authorize_site
  end

  def authorize_path
    self[:authorize_path] || "/oauth/authorize"
  end

  private

  def default_authorize_site
    case environment.to_sym
    when :development
      "http://nucleus.dev"
    when :production
      "https://login.watermark.org"
    end
  end

end
