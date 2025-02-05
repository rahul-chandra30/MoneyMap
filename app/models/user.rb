class User < ApplicationRecord
  has_many :expenses
  has_many :expenditures
  self.primary_key = 'user_id'
  has_secure_password
  has_many :expenses, foreign_key: 'user_id', dependent: :destroy  
end