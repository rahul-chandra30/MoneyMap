class MessagesController < ApplicationController
  before_action :authenticate_user!, only: :user_chat
  before_action :authenticate_expert!, only: :expert_chat

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages.new(message_params)
    @message.sender = current_user || current_expert

    Rails.logger.info "=========== NEW MESSAGE ==========="
    Rails.logger.info "Chat Room: #{@chat_room.id}"
    Rails.logger.info "Sender: #{@message.sender.name}"
    Rails.logger.info "Content: #{@message.content}"
    Rails.logger.info "=================================="

    if @message.save
      ChatChannel.broadcast_to(@chat_room, {
        message: render_to_string(partial: 'messages/message', locals: { 
          message: @message,
          current_user: current_user,
          current_expert: current_expert 
        })
      })
      head :ok
    else
      Rails.logger.error "Message errors: #{@message.errors.full_messages}"
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end