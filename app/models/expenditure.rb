class Expenditure < ApplicationRecord
  def change
    remove_foreign_key :expenditures, :users
    add_foreign_key :expenditures, :users, primary_key: :user_id
  end
end