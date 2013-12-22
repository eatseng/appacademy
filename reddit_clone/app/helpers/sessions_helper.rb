module SessionsHelper
  def current_user
    User.find_by_session_token(session[:session_token])
  end

  def log_in_user(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def log_out_user(user)
    user.reset_session_token!
    session[:session_token] = nil
  end

  def logged_in?
    !current_user.nil?
  end

  def user_logged_in?
    redirect_to new_session_url unless logged_in?
  end
end
