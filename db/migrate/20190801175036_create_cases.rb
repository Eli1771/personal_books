class CreateCases < ActiveRecord::Migration
  def change
    create_table do |t|
      t.string :name
      t.string :description
      t.integer :room_id
      t.integer :shelf_count
    end
  end
end
