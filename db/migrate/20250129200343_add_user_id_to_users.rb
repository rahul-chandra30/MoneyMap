class AddUserIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :user_id, :primary_key
  end
end
