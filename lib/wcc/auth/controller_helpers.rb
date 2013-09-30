module WCC::Auth::ControllerHelpers

  def access_level
    current_user.access_level
  end

  def self.included(receiver)
    receiver.helper_method :access_level
  end

end
