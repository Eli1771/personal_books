class AddUserIdsToTopicsAndCases < ActiveRecord::Migration
  def change
    add_column :topics, :user_id, :integer
    add_column :cases, :user_id, :integer
  end
end
