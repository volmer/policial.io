class AuthController < ApplicationController
  def github
    self.current_user = User.new(
      token: auth_hash['credentials']['token'],
      avatar_url: auth_hash['extra']['raw_info']['avatar_url'],
      name: auth_hash['extra']['raw_info']['name']
    )
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
