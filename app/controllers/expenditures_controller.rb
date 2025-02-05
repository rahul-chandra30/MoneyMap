class ExpendituresController < ApplicationController
  before_action :authenticate_user!

  def show
    month_number = Date::MONTHNAMES.index(params[:month])
    expenditure = current_user.expenditures.find_by(
      year: params[:year],
      month: month_number
    )
    render json: { income: expenditure&.income || 0 }
  end

  def create
    month_number = Date::MONTHNAMES.index(params[:month])
    expenditure = current_user.expenditures.find_or_initialize_by(
      year: params[:year],
      month: month_number
    )
    expenditure.income = params[:income]

    if expenditure.save
      render json: { success: true, message: "Income saved successfully" }
    else
      render json: { success: false, error: expenditure.errors.full_messages }, 
             status: :unprocessable_entity
    end
  end

  def update
    month_number = Date::MONTHNAMES.index(params[:month])
    expenditure = current_user.expenditures.find_by!(
      year: params[:year],
      month: month_number
    )

    if expenditure.update(income: params[:income])
      render json: { success: true, message: "Income updated successfully" }
    else
      render json: { success: false, error: expenditure.errors.full_messages }, 
             status: :unprocessable_entity
    end
  end

  private

  def expenditure_params
    params.permit(:year, :month, :income)
  end
end
