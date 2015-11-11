class OmniAuth::Strategies::Watermark < OmniAuth::Strategies::OAuth2
  option :name, :watermark

  option :client_options, {
    site: WCC::Auth.config.authorize_site,
    authorize_path: WCC::Auth.config.authorize_path,
  }

  option :authorize_params, WCC::Auth.config.authorize_params

  uid do
    raw_info["id"]
  end

  info do
    {
      email: raw_info["email"],
      first_name: raw_info["first_name"],
      last_name: raw_info["last_name"],
      access_level_id: raw_info["access_level_id"],
      arena_id: raw_info["arena_id"],
      applications: raw_info["applications"]
    }
  end

  def callback_url
    full_host + script_name + callback_path
  end

  def raw_info
    @raw_info ||= access_token.get('/api/v1/me.json').parsed
  end

end
