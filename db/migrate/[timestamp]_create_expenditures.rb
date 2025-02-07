class CreateExpenditures < ActiveRecord::Migration[7.0]
  def change
    create_table :expenditures do |t|
      t.string :user_id
      t.integer :year
      t.string :month
      t.decimal :income, precision: 10, scale: 2
      t.timestamps
    end
    add_index :expenditures, [:user_id, :year, :month], unique: true
  end
end