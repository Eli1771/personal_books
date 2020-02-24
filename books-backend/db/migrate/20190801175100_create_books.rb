class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :notes
      t.integer :author_id
      t.integer :topic_id
      t.integer :case_id
      t.integer :shelf_id

      t.timestamps null: false
    end
  end
end
