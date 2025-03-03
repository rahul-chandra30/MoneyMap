class DashboardController < ApplicationController
  before_action :authenticate_user!, only: [ :index ]

  def index
    @year = params[:year] || Time.current.year
    @month = params[:month] || Time.current.strftime("%B")
    @monthly_data = fetch_monthly_data(@year)
    @expense_breakdown = fetch_expense_breakdown(@year, @month)
  end

  def data
    year = params[:year]
    month = params[:month]

    data = {
      total_income: current_user.expenditures
        .where(year: year, month: Date::MONTHNAMES.index(month))
        .sum(:income),
      total_expenses: current_user.expenses
        .where(year: year, month: month)
        .sum(:amount_spent),
      expenses: current_user.expenses
        .where(year: year, month: month)
        .select(:category, :amount_spent),
      monthly_data: fetch_monthly_data(year),
      expense_breakdown: fetch_expense_breakdown(year, month)
    }

    data[:savings] = data[:total_income] - data[:total_expenses]
    data[:savings_status] = data[:savings] >= 0 ? "positive" : "negative"

    render json: data
  end

  private

  def fetch_monthly_data(year)
    incomes = current_user.expenditures
      .where(year: year)
      .group(:month)
      .sum(:income)

    expenses = current_user.expenses
      .where(year: year)
      .group(:month)
      .sum(:amount_spent)

    (1..12).map do |month|
      income = incomes[month] || 0
      expense = expenses[month.to_s] || 0
      {
        name: Date::MONTHNAMES[month],
        data: {
          "Income" => income,
          "Savings" => [ income - expense, 0 ].max
        }
      }
    end
  end

  def fetch_expense_breakdown(year, month)
    current_user.expenses
      .where(year: year, month: month)
      .group(:category)
      .sum(:amount_spent)
  end
end
