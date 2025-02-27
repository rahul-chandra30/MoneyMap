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
    month_number = Date::MONTHNAMES.index(params[:month])
    expenses = current_user.expenses.where(year: params[:year], month: month_number)
    render json: { expenses: expenses.map { |e| { category: e.category, amount_spent: e.amount_spent } } }
  end

  def create
    ActiveRecord::Base.transaction do
      month_number = Date::MONTHNAMES.index(params[:month])
      
      current_user.expenses.where(year: params[:year], month: month_number).delete_all

      params[:expenses].each do |expense|
        new_expense = current_user.expenses.create!(
          year: params[:year],
          month: month_number,
          category: expense[:category],
          amount_spent: expense[:amount_spent]
        )
        current_user.send_notification(
          "Expense Added",
          "#{new_expense.category} ₹#{new_expense.amount_spent}"
        )
      end

      render json: { success: true, message: "Expenses saved successfully" }
    rescue => e
      render json: { success: false, error: e.message }, status: :unprocessable_entity
    end
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
    params.permit(:year, :month, :category, :amount_spent, expenses: [:category, :amount_spent])
  end
end