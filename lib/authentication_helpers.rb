module AuthenticationHelpers
  def require_authentication
    redirect '/login' unless logged_in?
  end

  def current_user
    warden_handler.user
  end

  def authenticate_user!
    warden_handler.authenticate!
  end

  def logout_user!
    warden_handler.logout
  end

  def logged_in?
    !warden_handler.nil? && warden_handler.authenticated?
  end

  def warden_handler
    request.env['warden']
  end
end
