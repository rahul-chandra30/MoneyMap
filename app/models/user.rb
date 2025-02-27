class User < ApplicationRecord
  has_secure_password

  has_many :bookings, foreign_key: "user_id"
  has_many :expenses
  has_many :expenditures
  has_many :chat_rooms
  has_many :experts, through: :chat_rooms
  has_many :messages, as: :sender
  has_many :notifications, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :phone, presence: true

  def send_notification(title, message)
    notification = notifications.create!(
      title: title,
      message: message,
      read: false
    )

    ActionCable.server.broadcast(
      "notifications_channel_#{id}",
      {
        id: notification.id,
        title: notification.title,
        message: notification.message,
        time: notification.created_at.strftime("%b %d, %Y %H:%M"),
        count: notifications.unread.count
      }
    )

    # Send email based on title type
    if title == "New Chat Message"
      NotificationMailer.chat_notification(self, title, message).deliver_later
    else
      NotificationMailer.expense_notification(self, title, message).deliver_later
    end

    notification
  end
end
