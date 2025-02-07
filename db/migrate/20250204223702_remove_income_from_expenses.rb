class RemoveIncomeFromExpenses < ActiveRecord::Migration[8.0]
  def change
    remove_column :expenses, :income, :decimal
  end
end