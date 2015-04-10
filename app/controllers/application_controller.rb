class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  add_flash_types :alert, :success

  rescue_from(ActiveRecord::RecordNotFound) { render_404 }

  private

  def render_404
    respond_to do |format|
      format.html do
        render file: "#{Rails.root}/public/404.html",
               layout: false, status: 404
      end
      format.all { render nothing: true, status: 404 }
    end
  end

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
