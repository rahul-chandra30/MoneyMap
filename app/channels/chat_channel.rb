class ChatChannel < ApplicationCable::Channel
  def subscribed
    @chat_room = ChatRoom.find(params[:room_id])
    stream_for @chat_room
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Chat room not found: #{e.message}"
    reject
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    @chat_room = ChatRoom.find(params[:room_id])
    message = @chat_room.messages.create!(
      content: data["content"],
      sender: current_user_or_expert
    )

    ChatChannel.broadcast_to(
      @chat_room,
      {
        type: "new_message",
        message: render_message(message)
      }
    )
  rescue => e
    Rails.logger.error "Error in receive: #{e.message}"
    transmit error: e.message
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(
      partial: "messages/message",
      locals: {
        message: message,
        current_user_or_expert: current_user_or_expert,
        sender_type: current_user_or_expert.class.name,
        sender_id: current_user_or_expert.id
      }
    )
  end
end
