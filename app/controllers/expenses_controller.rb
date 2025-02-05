class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def new
    @year = params[:year] || Date.today.year
    @month = params[:month] || Date.today.strftime("%B")
    month_number = Date::MONTHNAMES.index(@month)
    @expenses = current_user.expenses.where(year: @year, month: month_number)
  end

  def create
    ActiveRecord::Base.transaction do
      month_number = Date::MONTHNAMES.index(params[:month])
      
      # Delete existing expenses
      current_user.expenses.where(
        year: params[:year],
        month: month_number
      ).delete_all

      # Create new expenses
      params[:expenses].each do |expense|
        current_user.expenses.create!(
          year: params[:year],
          month: month_number,
          category: expense[:category],
          amount_spent: expense[:amount_spent]
        )
      end

      render json: { success: true, message: "Expenses saved successfully" }
    end
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def expense_params
    params.permit(expenses: [:category, :amount_spent])
  end
end