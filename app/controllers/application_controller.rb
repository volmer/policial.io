class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  private

  def current_user=(user)
    session[:current_user] = user.as_json
  end

  def current_user
    current_user_hash = session[:current_user]
    User.new(current_user_hash) if current_user_hash.present?
  end

  def require_login
    return if current_user.present?
    flash[:notice] = 'Please login.'
    redirect_to :root
  end
end
