class WCC::Auth::Devise::WatermarkCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check if respond_to?(:skip_authorization_check)

  def watermark
    oauth_data = request.env["omniauth.auth"]
    @user = User.initialize_from_watermark_oauth(oauth_data)
    @user.save

    sign_in_and_redirect @user
  end

  def failure
    Rails.logger.error failed_strategy.name
    Rails.logger.error failure_message
    set_flash_message :alert, :failure, :kind => OmniAuth::Utils.camelize(failed_strategy.name), :reason => failure_message
    redirect_to after_omniauth_failure_path_for(resource_name)
  end

  protected

  def after_omniauth_failure_path_for(scope)
    root_path
  end

end

