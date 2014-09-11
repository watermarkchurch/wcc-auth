WCC::Auth::Config = Struct.new(:environment,
                               :app_name,
                               :app_url,
                               :app_url_protocol,
                               :app_id,
                               :app_secret,
                               :app_domain_suffix,
                               :authorize_site,
                               :authorize_path,
                               :authorize_params) do

  def authorize_site
    self[:authorize_site] || ENV['WCC_AUTHORIZE_SITE'] || default_authorize_site
  end

  def authorize_path
    self[:authorize_path] || ENV['WCC_AUTHORIZE_PATH'] || "/oauth/authorize"
  end

  def authorize_params
    self[:authorize_params] || {}
  end

  def app_url
    self[:app_url] || ENV['APP_URL'] || default_app_url
  end

  def app_url_protocol
    self[:app_domain_suffix] || default_app_url_protocol
  end

  def app_domain_suffix
    self[:app_domain_suffix] || default_app_domain_suffix
  end

  def nucleus_url
    return ENV['NUCLEUS_URL'] if ENV['NUCLEUS_URL']

    case environment.to_sym
    when :production
      "https://login.watermark.org"
    when :staging
      "http://login.staging.watermark.org"
    when :development
      "http://login.dev"
    end
  end

  private

  def default_app_url
    "#{app_url_protocol}://#{app_name}#{app_domain_suffix}"
  end

  def default_app_url_protocol
    case environment.to_sym
    when :production
      "https"
    else
      "http"
    end
  end

  def default_app_domain_suffix
    case environment.to_sym
    when :production
      ".watermark.org"
    when :staging
      ".staging.watermark.org"
    when :development
      ".dev"
    end
  end

  def default_authorize_site
    nucleus_url
  end

end
