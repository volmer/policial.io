class User
  include ActiveModel::Model
  attr_accessor :token, :name, :avatar_url, :login

  def client
    Octokit::Client.new(access_token: token, auto_paginate: true)
  end
end
