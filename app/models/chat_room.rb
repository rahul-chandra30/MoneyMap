class ChatRoom < ApplicationRecord
  belongs_to :user
  belongs_to :expert
  has_many :messages, dependent: :destroy
end
