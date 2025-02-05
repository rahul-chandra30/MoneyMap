class Expenditure < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'
  validates :year, :month, :income, presence: true
end