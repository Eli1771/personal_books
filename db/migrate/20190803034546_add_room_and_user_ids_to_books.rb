class AddRoomAndUserIdsToBooks < ActiveRecord::Migration
  def change
    add_column :books, :user_id, :integer
    add_column :books, :room_id, :integer
  end
end
