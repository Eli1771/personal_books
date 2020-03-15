class RemoveBookIdFromAuthors < ActiveRecord::Migration
  def change
    remove_column :authors, :book_id, :integer
  end
end
