class DashboardController < ApplicationController
  before_action :authenticate_user!, only: [ :index ]

  def index
    @year = params[:year] || Time.current.year
    @month = params[:month] || Time.current.strftime("%B")
    @initial_data = fetch_data_for_broadcast(current_user, @year, @month)
  end

  def data
    year = params[:year].to_i
    month = params[:month]
    render json: fetch_data_for_broadcast(current_user, year, month)
  end

  private

  def fetch_data_for_broadcast(user, year, month)
    month_number = Date::MONTHNAMES.index(month)

    # Single month data
    expenditure = user.expenditures.find_by(year: year, month: month_number)
    expenses = user.expenses.where(year: year, month: month)
    total_income = expenditure&.income.to_i || 0
    total_expenses = expenses.sum(:amount_spent) || 0
    savings = total_income - total_expenses

    # Yearly data for charts
    yearly_data = process_yearly_data(user, year)

    {
      total_income: total_income,
      total_expenses: total_expenses,
      savings: savings >= 0 ? savings : 0,
      savings_status: get_savings_status(savings),
      expenses: expenses.select(:category, :amount_spent).map { |e|
        { category: e.category, amount_spent: e.amount_spent.to_i }
      },
      monthly_data: yearly_data,
      expense_breakdown: expenses.group(:category).sum(:amount_spent)
    }
  end

  def process_yearly_data(user, year)
    yearly_incomes = user.expenditures
      .where(year: year)
      .group(:month)
      .sum(:income)

    yearly_expenses = user.expenses
      .where(year: year)
      .group(:month)
      .sum(:amount_spent)

    (1..12).map do |month|
      month_name = Date::MONTHNAMES[month]
      income = yearly_incomes[month].to_i
      expenses = yearly_expenses[month_name].to_i

      {
        name: month_name,
        data: {
          "Income" => income,
          "Savings" => [ income - expenses, 0 ].max
        }
      }
    end
  end

  def get_savings_status(savings)
    if savings > 0
      "positive"
    elsif savings == 0
      "zero"
    else
      "negative"
    end
  end
end
