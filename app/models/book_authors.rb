class BookAuthor < ActiveRecord::Base
  belongs_to :book_id
  belongs_to :author_id
end
