class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  add_flash_types :alert, :success

  rescue_from(ActiveRecord::RecordNotFound) { render_404 }

  def new_session_path(_scope)
    new_user_session_path
  end

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

  def require_login
    render 'repositories/guest_index' unless user_signed_in?
  end

  def ensure_access
    return if user_signed_in? && current_user.repositories.include?(@repository)
    render_404
  end
end
