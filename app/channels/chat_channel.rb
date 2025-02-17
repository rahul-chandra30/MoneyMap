class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat_room = ChatRoom.find(params[:room])
    stream_for chat_room
    logger.info "Subscribed to ChatRoom #{chat_room.id}"
  end

  def unsubscribed
    stop_all_streams
    logger.info "Unsubscribed from ChatRoom"
  end
end