class ChatRoom < ApplicationRecord
  belongs_to :user
  belongs_to :expert
  has_many :messages, dependent: :destroy
  
  validates :user_id, presence: true
  validates :expert_id, presence: true
end
