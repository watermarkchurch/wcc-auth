class OmniAuth::Strategies::Watermark < OmniAuth::Strategies::OAuth2
  option :name, :watermark

  option :client_options, {
    :site => WCC::Auth.config.provider,
    :authorize_path => WCC::Auth.config.authorize_path,
  }

  uid do
    raw_info["id"]
  end

  info do
    {
      :email => raw_info["email"]
    }
  end

  def raw_info
    @raw_info ||= access_token.get('/api/v1/me.json').parsed
  end

end
