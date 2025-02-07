class ChangeAmountSpentFormat < ActiveRecord::Migration[7.0]
  def up
    change_column :expenses, :amount_spent, :integer
  end

  def down
    change_column :expenses, :amount_spent, :decimal
  end
end