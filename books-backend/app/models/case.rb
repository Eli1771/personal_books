class Case < ActiveRecord::Base
  belongs_to :room
  has_many :books
end
