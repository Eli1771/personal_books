class CreateCases < ActiveRecord::Migration
  def change
    create_table :cases do |t|
      t.string :name
      t.string :description
      t.integer :room_id
      t.integer :shelf_count

      t.timestamps null: false
    end
  end
end
