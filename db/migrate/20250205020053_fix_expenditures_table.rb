class FixExpendituresTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :expenditures
    
    create_table :expenditures do |t|
      t.references :user, null: false, foreign_key: { to_table: :users, primary_key: :user_id }
      t.integer :year
      t.integer :month
      t.decimal :income
      t.timestamps
    end
  end
end