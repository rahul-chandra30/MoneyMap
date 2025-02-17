class Expert < ApplicationRecord
  has_secure_password
  has_many :bookings
  has_many :chat_rooms
  has_many :users, through: :chat_rooms
  has_many :messages, as: :sender

  validates :email, presence: true, uniqueness: true
  validates :name, :phone, presence: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :gender, inclusion: { in: ['Male', 'Female', 'Other'] }, allow_nil: true
  validates :experience, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :designation, length: { maximum: 100 }, allow_nil: true
  validates :charges_per_session, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end