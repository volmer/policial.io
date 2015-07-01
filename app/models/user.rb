class User < ActiveRecord::Base
  devise :omniauthable, :rememberable, :trackable,
         omniauth_providers: [:github]

  validates :uid, presence: true, uniqueness: true
  validates :token, presence: true

  def client
    Octokit::Client.new(access_token: token, auto_paginate: true)
  end

  def self.from_omniauth(auth)
    where(uid: auth[:uid]).first_or_create do |user|
      user.assign_attributes(
        auth[:info].slice(:name, :nickname, :image, :email)
      )
      user.token = auth[:credentials][:token]
    end
  end
end
