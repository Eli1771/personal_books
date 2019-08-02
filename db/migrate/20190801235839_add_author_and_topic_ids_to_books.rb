class AddAuthorAndTopicIdsToBooks < ActiveRecord::Migration
  def change
    add_column :books, :author_id, :integer

    add_column :books, :topic_id, :integer
  end
end
