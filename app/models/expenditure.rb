class Expenditure < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, primary_key: :user_id
  validates :year, :month, :income, presence: true
  validates :income, numericality: { greater_than_or_equal_to: 0 }
  
  before_save :format_income
  
  private
  
  def format_income
    self.income = income.to_i
  end
end