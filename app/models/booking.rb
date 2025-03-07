class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :expert

  validates :booking_id, presence: true, uniqueness: true
  validates :user_name, :expert_name, presence: true
  validates :session_date, :time_slot, presence: true

  before_validation :set_names, on: :create
  before_validation :generate_booking_id, on: :create

  private

  def generate_booking_id
    self.booking_id ||= "BOOK#{SecureRandom.hex(5).upcase}"
  end

  def set_names
    self.user_name ||= user&.name
    self.expert_name ||= expert&.name
  end
end