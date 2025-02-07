class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @year = params[:year] || Time.current.year
    @month = params[:month] || Time.current.strftime("%B")
  end

  def data
    year = params[:year]
    month = params[:month]
    month_number = Date::MONTHNAMES.index(month)

    # Get income from expenditures table
    expenditure = current_user.expenditures.find_by(year: year.to_i, month: month_number)

    # Get expenses from expenses table
    expenses = current_user.expenses.where(year: year.to_i, month: month_number)

    total_income = expenditure&.income.to_i
    total_expenses = expenses.sum(:amount_spent)
    savings = total_income - total_expenses

    response = {
        total_income: total_income,
        total_expenses: total_expenses,
        savings: savings >= 0 ? savings : 0,
        savings_status: get_savings_status(savings),
        expenses: expenses.map { |e| {
            category: e.category,
            amount_spent: e.amount_spent
        }}
    }

    render json: response
  end

  private

  def get_savings_status(savings)
    if savings > 0
      'positive'
    elsif savings == 0
      'zero'
    else
      'negative'
    end
  end
end