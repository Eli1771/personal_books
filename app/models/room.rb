class Room < ActiveRecord::Base
  belongs_to :user
  has_many :cases
  has_many :shelves, through: :cases
  has_many :books, through: :shelves
end
