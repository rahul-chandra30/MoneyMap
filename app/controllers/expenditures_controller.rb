class ExpendituresController < ApplicationController
  before_action :authenticate_user!

  def show
    year = params[:year].to_i
    month = Date::MONTHNAMES.index(params[:month])
    expenditure = current_user.expenditures.find_by(year: year, month: month)
    render json: { income: expenditure&.income }
  end

  def create
    # Find existing expenditure or create new one
    month_number = Date::MONTHNAMES.index(params[:month])
    expenditure = current_user.expenditures.find_or_initialize_by(
      year: params[:year],
      month: month_number
    )

    expenditure.income = params[:income]

    if expenditure.save
      render json: { message: "Income saved successfully" }, status: :ok
    else
      render json: { error: expenditure.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  def expenditure_params
    params.permit(:year, :month, :income)
  end
end
