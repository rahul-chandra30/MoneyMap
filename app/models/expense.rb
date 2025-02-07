class Expense < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, primary_key: :user_id
  validates :year, :month, :category, :amount_spent, presence: true
  validates :amount_spent, numericality: { greater_than: 0 }

  scope :for_month_year, ->(month, year) { where(month: month, year: year) }
  scope :total_spent, -> do
    sum(:amount_spent)
  end

  # Format amount before save
  before_save :format_amount

  private

  def format_amount
    self.amount_spent = amount_spent.to_i
  end
end