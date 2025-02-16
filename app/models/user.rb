class User < ApplicationRecord
  has_secure_password
   has_many :bookings, foreign_key: 'user_id' 
  has_many :expenses
  has_many :expenditures
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :phone, presence: true
  has_many :chat_rooms, foreign_key: :user_id, dependent: :destroy
end