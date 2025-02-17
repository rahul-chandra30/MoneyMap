class Message < ApplicationRecord
  belongs_to :chat_room
  belongs_to :sender, polymorphic: true

  validates :content, presence: true
  validates :sender, presence: true
  validates :chat_room, presence: true

  after_create_commit -> { broadcast_append_to chat_room }
end
