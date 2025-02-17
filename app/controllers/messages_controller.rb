class MessagesController < ApplicationController
  before_action :authenticate_user_or_expert!

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages.new(message_params)
    @message.sender = current_user || current_expert

    if @message.save
      ChatChannel.broadcast_to(@chat_room, {
        message: render_to_string(partial: 'messages/message', locals: { message: @message })
      })
      head :ok
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end