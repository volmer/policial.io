class User < ActiveRecord::Base
  devise :omniauthable, :rememberable, :trackable,
         omniauth_providers: [:github]

  has_and_belongs_to_many :repositories

  validates :uid, presence: true, uniqueness: true

  after_create :associate_repositories, if: :token?

  def client
    @client ||= Octokit::Client.new(access_token: token, auto_paginate: true)
  end

  def self.from_omniauth(auth)
    where(uid: auth[:uid]).first_or_create do |user|
      user.assign_attributes(
        auth[:info].slice(:name, :nickname, :image, :email)
      )
      user.token = auth[:credentials][:token]
    end
  end

  def new_repositories
    client.repositories.reject do |repo|
      repositories.map(&:name).include?(repo.full_name)
    end
  end

  def associate_repositories
    self.repositories = Repository.where(
      name: client.repositories.map(&:full_name)
    )
  end
end
