# app/controllers/expenses_controller.rb
class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def new
    @year = params[:year] || Date.today.year
    @month = params[:month] || Date.today.strftime("%B")
    month_number = Date::MONTHNAMES.index(@month)
    @expenses = current_user.expenses.where(year: @year, month: month_number)
  end

  def show
    year = params[:year]
    month = params[:month]
    expenses = current_user.expenses.where(year: year, month: month)
    render json: { expenses: expenses }
  end

  def create
    ActiveRecord::Base.transaction do
      # Delete existing expenses for this month/year
      current_user.expenses
        .where(year: expense_params[:year], month: expense_params[:month])
        .destroy_all

      # Create new expenses
      expense_params[:expenses].each do |expense|
        current_user.expenses.create!(
          year: expense_params[:year],
          month: expense_params[:month],
          category: expense[:category],
          amount_spent: expense[:amount_spent]
        )
      end

      render json: { message: "Expenses saved successfully" }, status: :ok
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def update
    month_number = Date::MONTHNAMES.index(params[:month])
    expense = current_user.expenses.find_by!(
      year: params[:year],
      month: month_number,
      category: params[:category]
    )

    if expense.update(amount_spent: params[:amount_spent])
      current_user.send_notification(
        "Expense Updated",
        "#{expense.category} now ₹#{expense.amount_spent}"
      )
      render json: { success: true, message: "Expense updated successfully" }
    else
      render json: { success: false, error: expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def expense_params
    params.require(:expense).permit(
      :year,
      :month,
      expenses: [ :category, :amount_spent ]
    )
  end
end
