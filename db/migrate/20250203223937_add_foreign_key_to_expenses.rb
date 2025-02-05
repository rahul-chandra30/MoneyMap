class AddForeignKeyToExpenses < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :expenses, :users if foreign_key_exists?(:expenses, :users)
    add_foreign_key :expenses, :users, primary_key: 'user_id'
    add_index :expenses, :user_id unless index_exists?(:expenses, :user_id)
  end
end