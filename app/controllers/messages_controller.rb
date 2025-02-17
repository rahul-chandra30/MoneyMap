class MessagesController < ApplicationController
  before_action :authenticate_user!


  def create
  @chat_room = ChatRoom.find(params[:chat_room_id])
  @message = @chat_room.messages.new(message_params)
  @message.sender = current_user || current_expert

  if @message.save
    puts "Sender: #{@message.sender.name}" 
    ActionCable.server.broadcast("chat_room_#{@chat_room.id}", {
      sender: @message.sender.name,
      content: @message.content,
      timestamp: @message.created_at.strftime("%H:%M")
    })
    head :ok
  else
    render json: { error: "Failed to send message" }, status: :unprocessable_entity
  end
end

  private

  def message_params
    params.require(:message).permit(:content, :sender_type, :sender_id)
  end
end