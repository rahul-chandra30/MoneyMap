class Notification < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true
  validates :message, presence: true
  
  scope :recent, -> { order(created_at: :desc).limit(5) }
  scope :unread, -> { where(read: false) }
end