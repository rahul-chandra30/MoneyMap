class BookingsController < ApplicationController
  before_action :authenticate_user!

  def create
    expert = Expert.find(params[:expert_id])
    amount = expert.charges_per_session.presence || 1.0

    @booking = Booking.new(
      user: current_user,
      expert: expert,
      user_name: current_user.name,
      expert_name: expert.name,
      session_date: params[:session_date],
      time_slot: params[:time_slot],
      charges_paid: amount,
      payment_status: 'pending',
      booking_timestamp: Time.current
    )

    if @booking.save
      order = Razorpay::Order.create(
        amount: (amount * 100).to_i,
        currency: 'INR',
        receipt: @booking.booking_id
      )

      @booking.update(razorpay_order_id: order.id)
      
      render json: {
        id: order.id,
        amount: order.amount,
        currency: order.currency,
        booking_id: @booking.booking_id
      }
    else
      render json: { error: @booking.errors.full_messages }, 
             status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def payment_callback
    @booking = Booking.find_by(booking_id: params[:booking_id])
    
    if @booking
      @booking.update(
        payment_status: 'completed',
        razorpay_payment_id: params[:razorpay_payment_id]
      )
      render json: { success: true }
    else
      render json: { success: false }, status: :not_found
    end
  end

  def index
    @bookings = current_user.bookings.order(created_at: :desc)
  end
end
