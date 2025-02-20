class ExpendituresController < ApplicationController
  before_action :authenticate_user!

  # Remove duplicate show method and update the remaining one
  def show
    month_number = Date::MONTHNAMES.index(params[:month])
    expenditure = current_user.expenditures.find_by(
      year: params[:year],
      month: month_number
    )
    render json: { success: true, income: expenditure&.income || 0 }
  end

  def create
    month_number = Date::MONTHNAMES.index(params[:month])
    
    expenditure = current_user.expenditures.find_or_initialize_by(
      year: params[:year],
      month: month_number
    )
    
    expenditure.income = params[:income]

    if expenditure.save
      render json: { 
        success: true, 
        message: "Income saved successfully",
        income: expenditure.income 
      }
    else
      render json: { 
        success: false, 
        error: expenditure.errors.full_messages.join(", ") 
      }, status: :unprocessable_entity
    end
  rescue => e
    render json: { 
      success: false, 
      error: "Failed to save income: #{e.message}" 
    }, status: :internal_server_error
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
