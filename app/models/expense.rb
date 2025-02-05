class Expense < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'
  validates :year, :month, :category, :amount_spent, presence: true
end