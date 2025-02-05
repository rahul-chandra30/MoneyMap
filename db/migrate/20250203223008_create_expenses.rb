class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :year
      t.string :month
      t.decimal :income
      t.string :category
      t.decimal :amount_spent
      t.timestamps
    end
  end
end
