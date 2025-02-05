class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @user = current_user
    @total_expenses = @user.expenses.sum(:amount_spent)
    @total_income = @user.expenditures.sum(:income) # Use expenditures for income
    @remaining_budget = @total_income - @total_expenses

    @current_month_expenses = @user.expenses.where(month: Date.today.month, year: Date.today.year).group_by(&:category).map { |category, expenses| [category, expenses.sum(&:amount_spent)] }.to_h
    @categories = @current_month_expenses.keys
    @expense_amounts = @current_month_expenses.values

    @expenses = @user.expenses.order(created_at: :desc)
  end

  def index
    @user = current_user
    @expenses = @user.expenses.order(created_at: :desc)
  end

  def show
    @user = current_user
    month_number = Date::MONTHNAMES.index(params[:month])

    @expenses = @user.expenses.where(year: params[:year], month: month_number)

    @income = @user.expenditures.find_by(year: params[:year], month: month_number)&.income || 0

    render json: {
      income: @income,
      expenses: @expenses.map { |e| { category: e.category, amount_spent: e.amount_spent } }
    }
  end

def new
  @year = params[:year] || Date.today.year
  # Use Date.today.strftime("%B") to get the full month name
  @month = params[:month] || Date.today.strftime("%B") # Change this line

  month_number = Date::MONTHNAMES.index(@month)

  @existing_expenses = current_user.expenses.where(year: @year, month: month_number)

  expenditure = current_user.expenditures.find_by(year: @year, month: month_number)
  @income_value = expenditure&.income || 0
end

  def create
    month_number = Date::MONTHNAMES.index(params[:month])

    begin
      ActiveRecord::Base.transaction do
        expenditure = current_user.expenditures.find_or_initialize_by(year: params[:year], month: month_number)
        expenditure.income = params[:income]
        expenditure.save!

        current_user.expenses.where(year: params[:year], month: month_number).delete_all

        if params[:expense]
          params[:expense][:category].each_with_index do |category, index|
            amount = params[:expense][:amount][index]
            if amount.present? && !amount.to_f.negative? # Validate Amount
              current_user.expenses.create!(
                year: params[:year],
                month: month_number,
                category: category,
                amount_spent: amount
              )
            end
          end
        end
      end

      redirect_to new_expense_path(year: params[:year], month: params[:month]), notice: "Data saved successfully!"
    rescue ActiveRecord::RecordInvalid => e  # Catch record invalid errors
      redirect_to new_expense_path(year: params[:year], month: params[:month]), alert: "Error: #{e.message}"
    rescue => e # Catch other errors
      redirect_to new_expense_path(year: params[:year], month: params[:month]), alert: "Error: #{e.message}"
    end
  end

  def edit
    @expense = current_user.expenses.find(params[:id])
  end

  def update
    @expense = current_user.expenses.find(params[:id])
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: 'Expense was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @expense = current_user.expenses.find(params[:id])
    @expense.destroy
    redirect_to expenses_path, notice: 'Expense was successfully destroyed.'
  end

  private

  def expense_params
    params.require(:expense).permit(:category, :amount_spent, :year, :month, :income)
  end
end