class ChangeUserNameNullConstraintInBookings < ActiveRecord::Migration[7.0]
  def change
    # Ensure existing NULL values are updated
    Booking.where(user_name: nil).update_all(user_name: 'Unknown User')

    # Add NOT NULL constraint
    change_column_null :bookings, :user_name, false
  end
end