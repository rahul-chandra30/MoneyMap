class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :expert, null: false, foreign_key: true
      t.string :user_name
      t.string :expert_name
      t.decimal :charges_paid, precision: 10, scale: 2
      t.date :session_date
      t.string :time_slot
      t.string :razorpay_order_id
      t.string :razorpay_payment_id
      t.string :payment_status, default: 'pending'
      t.string :booking_id

      t.timestamps
    end
    
    add_index :bookings, :booking_id, unique: true
  end
end