class User < ActiveRecord::Base

  has_secure_password

  has_many :rooms
  has_many :topics
  has_many :authors
  has_many :cases, through: :rooms
  has_many :books, through: :cases
end
