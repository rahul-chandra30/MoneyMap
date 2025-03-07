class BookingsController < ApplicationController
  before_action :authenticate_user!

  def create
    @booking = Booking.new(
      user: current_user,
      expert: Expert.find(params[:expert_id]),
      user_name: current_user.name,
      expert_name: Expert.find(params[:expert_id]).name,
      session_date: params[:session_date],
      time_slot: params[:time_slot],
      booking_timestamp: Time.current
    )

    if Booking.exists?(expert_id: @booking.expert_id, session_date: @booking.session_date, time_slot: @booking.time_slot)
      render json: { error: "This time slot is already booked for this expert." }, status: :unprocessable_entity
      return
    end

    if @booking.save
      # Broadcast to BookingsChannel
      ActionCable.server.broadcast("bookings_channel_#{@booking.expert_id}", {
        action: "booking_created",
        expert_id: @booking.expert_id,
        session_date: @booking.session_date,
        time_slot: @booking.time_slot
      })

      # Broadcast notifications
      ActionCable.server.broadcast("notifications_channel_#{current_user.id}", {
        title: "Booking Confirmed",
        message: "You’ve booked #{@booking.expert_name} on #{@booking.session_date} at #{@booking.time_slot}.",
        time: Time.current.strftime("%H:%M")
      })
      ActionCable.server.broadcast("notifications_channel_#{@booking.expert_id}", {
        title: "New Booking",
        message: "#{@booking.user_name} has booked you on #{@booking.session_date} at #{@booking.time_slot}.",
        time: Time.current.strftime("%H:%M")
      })

      # Send emails
      BookingMailer.user_confirmation(@booking).deliver_later
      BookingMailer.expert_notification(@booking).deliver_later

      render json: { success: true, booking_id: @booking.booking_id }
    else
      render json: { error: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def available_slots
    expert_id = params[:expert_id]
    date = params[:date]
    booked_slots = Booking.where(expert_id: expert_id, session_date: date).pluck(:time_slot)
    render json: { booked: booked_slots }
  end

  def index
    @bookings = current_user.bookings.order(created_at: :desc)
  end
end