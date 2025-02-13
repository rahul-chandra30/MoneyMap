class AddNamesToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :user_name, :string, null: false
    add_column :bookings, :expert_name, :string, null: false
  end
end