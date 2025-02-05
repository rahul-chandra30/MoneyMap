class User < ApplicationRecord
  self.primary_key = :user_id
  
  has_many :expenditures
  self.primary_key = 'user_id'
has_many :expenses, foreign_key: :user_id
  has_many :expenditures, foreign_key: :user_id
end