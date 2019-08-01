class Case < ActiveRecord::Base
  belongs_to :room
  has_many :shelves
  has_many :books, through: :shelves
end
