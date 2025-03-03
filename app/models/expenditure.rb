class Expenditure < ApplicationRecord
  belongs_to :user
  validates :year, :month, :income, presence: true
  validates :income, numericality: { greater_than_or_equal_to: 0 }

  before_save :format_income
  after_commit :broadcast_update

  private

  def format_income
    self.income = income.to_i
  end

  def broadcast_update
    return unless user

    # Get the latest data for the current month and year
    month_name = Date::MONTHNAMES[month]
    data = {
      total_income: user.expenditures.where(year: year, month: month).sum(:income),
      total_expenses: user.expenses.where(year: year, month: month_name).sum(:amount_spent)
    }

    data[:savings] = data[:total_income] - data[:total_expenses]
    data[:savings_status] = data[:savings] >= 0 ? "positive" : "negative"

    DashboardChannel.broadcast_to(user, data)
  end
end
