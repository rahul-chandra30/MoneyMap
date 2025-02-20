class Expense < ApplicationRecord
  belongs_to :user
  validates :year, :month, :category, :amount_spent, presence: true
  validates :amount_spent, numericality: { greater_than: 0 }

  scope :for_month_year, ->(month, year) { where(month: month, year: year) }
  scope :total_spent, -> { sum(:amount_spent) }

  before_save :format_amount

  private

  def format_amount
    self.amount_spent = amount_spent.to_i
  end
end
