class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :topic
      t.integer :case_id
      t.integer :shelf_id

      t.timestamps null: false
    end
  end
end
