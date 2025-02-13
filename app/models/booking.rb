class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :expert

  validates :booking_id, presence: true, uniqueness: true
  validates :user_name, :expert_name, presence: true
  validates :charges_paid, numericality: { greater_than_or_equal_to: 0 }
  validates :session_date, :time_slot, presence: true
  validates :payment_status, inclusion: { in: ['pending', 'completed', 'failed'] }

  before_validation :set_names, on: :create
  before_validation :generate_booking_id, on: :create

  private

  def generate_booking_id
    self.booking_id ||= "BOOK#{SecureRandom.hex(5).upcase}"
  end

  def set_names
    if user
      self.user_name ||= user.name
    end
    if expert
      self.expert_name ||= expert.name
    end
  end
end