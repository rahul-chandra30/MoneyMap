class ChatChannel < ApplicationCable::Channel
  def subscribed
    @chat_room = ChatRoom.find(params[:room_id])
    stream_for @chat_room
    stream_for current_user_or_expertimport consumer from "./consumer"
  
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
  
    @message = @chat_room.messages.create!(
      content: data['content'],
      sender: current_user_or_expert
    )
    
    ChatChannel.broadcast_to(
      @chat_room,
      {
        message: ApplicationController.renderer.render(
          partial: 'messages/message',
          locals: { 
            message: @message,
            current_user_or_expert: current_user_or_expert 
          }
        )
      }
    )
  rescue => e
  
    transmit(error: e.message)
  end
end
