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

    expenditure = current_user.expenditures.find_by(year: year, month: month_number)
    expenses = current_user.expenses.where(year: year, month: month_number)
    
    total_income = expenditure&.income || 0
    total_expenses = expenses.sum(:amount_spent)
    savings = [total_income - total_expenses, 0].max # Ensure savings is never negative
    
    response = {
      total_income: total_income,
      total_expenses: total_expenses,
      savings: savings,
      expenses: expenses.map do |expense|
        {
          category: expense.category,
          amount_spent: expense.amount_spent
        }
      end
    }
    
    render json: response
  end
end