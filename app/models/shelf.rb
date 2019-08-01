class Shelf < ActiveRecord::Base
  belongs_to :case
  has_many :books
end 
