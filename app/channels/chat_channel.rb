class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat_room = ChatRoom.find(params[:room_id])
    stream_for chat_room
    logger.info "=========== SUBSCRIPTION ==========="
    logger.info "Connected to ChatRoom #{chat_room.id}"
    logger.info "Current sender: #{current_sender.name}"
    logger.info "===================================="
  end

  def unsubscribed
    stop_all_streams
  end

  def speak(data)
    chat_room = ChatRoom.find(params[:room_id])
    message = chat_room.messages.create!(
      content: data['content'],
      sender: current_sender
    )
    
    logger.info "=========== MESSAGE SENT ==========="
    logger.info "Room: #{chat_room.id}"
    logger.info "Sender: #{current_sender.name}"
    logger.info "Content: #{data['content']}"
    logger.info "=================================="
    
    ChatChannel.broadcast_to(chat_room, {
      message: ApplicationController.renderer.render(
        partial: 'messages/message',
        locals: { message: message }
      )
    })
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(
      partial: 'messages/message',
      locals: { message: message }
    )
  end
end