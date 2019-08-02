class Book < ActiveRecord::Base
  belongs_to :case
  has_many :book_authors
  has_many :book_topics
  has_many :authors, through: :book_authors
  has_many :topics, through: :book_topics
end
