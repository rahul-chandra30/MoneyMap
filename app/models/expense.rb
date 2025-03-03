class Expense < ApplicationRecord
  belongs_to :user
  validates :year, :month, :category, :amount_spent, presence: true
  validates :amount_spent, numericality: { greater_than: 0 }

  scope :for_month_year, ->(month, year) { where(month: month, year: year) }
  scope :total_spent, -> { sum(:amount_spent) }

  before_save :format_amount
  after_commit :broadcast_update

  private

  def format_amount
    self.amount_spent = amount_spent.to_i
  end

  def broadcast_update
    return unless user

    # Get the latest data for the current month and year
    data = {
      total_expenses: user.expenses.where(year: year, month: month).sum(:amount_spent),
      total_income: user.expenditures.where(year: year, month: Date::MONTHNAMES.index(month)).sum(:income)
    }

    data[:savings] = data[:total_income] - data[:total_expenses]
    data[:savings_status] = data[:savings] >= 0 ? "positive" : "negative"

    DashboardChannel.broadcast_to(user, data)
  end
end
