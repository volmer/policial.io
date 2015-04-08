class AuthController < ApplicationController
  def github
    user = auth_hash['extra']['raw_info'].slice(:name, :avatar_url, :login)
    user[:token] = auth_hash['credentials']['token']
    self.current_user = User.new(user)
    redirect_to :root
  end

  def logout
    self.current_user = nil
    redirect_to :root
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
