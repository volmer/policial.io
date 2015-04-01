class User
  include ActiveModel::Model
  attr_accessor :token, :name, :avatar_url
end
