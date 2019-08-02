class Book < ActiveRecord::Base
  belongs_to :case
  has_many :topics
  has_many :book_authors
  has_many :authors, through: :book_authors
end
