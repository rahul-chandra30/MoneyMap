# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :chat_room
  belongs_to :sender, polymorphic: true

  validates :content, presence: true
  validates :sender, presence: true

  after_create :broadcast_notification

  private

  def broadcast_notification
    user = chat_room.user
    sender_name = sender.is_a?(Expert) ? sender.name : "you"
    user.send_notification(
      "New Chat Message",
      "From #{sender_name}: '#{content.truncate(20)}'"
    )
  end
end