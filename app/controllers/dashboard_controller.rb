class DashboardController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @year = params[:year] || Time.current.year
    @month = params[:month] || Time.current.strftime("%B")
  end

  def data
    year = params[:year].to_i
    month = params[:month]
    month_number = Date::MONTHNAMES.index(month)
  
    # Single month data
    expenditure = current_user.expenditures.find_by(year: year, month: month_number)
    expenses = current_user.expenses.where(year: year, month: month)
    total_income = expenditure&.income.to_i || 0
    total_expenses = expenses.sum(:amount_spent) || 0
    savings = total_income - total_expenses
  
    # Yearly data for line chart
    yearly_incomes = current_user.expenditures.where(year: year).group(:month).sum(:income)
    yearly_expenses = current_user.expenses.where(year: year).group(:month).sum(:amount_spent)
    monthly_data = (1..12).map do |i|
      income = yearly_incomes[i] || 0
      expense = yearly_expenses[Date::MONTHNAMES[i]] || 0
      { income: income, savings: [income - expense, 0].max }
    end
  
    render json: {
      total_income: total_income,
      total_expenses: total_expenses,
      savings: savings >= 0 ? savings : 0,
      savings_status: get_savings_status(savings),
      expenses: expenses.map { |e| { category: e.category, amount_spent: e.amount_spent.to_i } },
      monthly_data: monthly_data
    }
  end

  private

  def get_savings_status(savings)
    if savings > 0 then 'positive' elsif savings == 0 then 'zero' else 'negative' end
  end
end