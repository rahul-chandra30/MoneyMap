class User < ApplicationRecord
  has_secure_password

  has_many :bookings, foreign_key: 'user_id' 
  has_many :expenses
  has_many :expenditures
  has_many :chat_rooms
  has_many :experts, through: :chat_rooms
  has_many :messages, as: :sender
  
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :phone, presence: true
end