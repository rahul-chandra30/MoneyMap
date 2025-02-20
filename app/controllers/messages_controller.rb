class MessagesController < ApplicationController
  before_action :authenticate_user_or_expert!

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages.build(message_params)
    @message.sender = current_user_or_expert

    if @message.save
      render json: { status: :created }
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
