class MessagesController < ApplicationController
  before_action :authenticate_user_or_expert!

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages.build(message_params)

    # Set the correct sender based on who is logged in
    @message.sender = if current_user
                       current_user
    elsif current_expert
                       current_expert
    end

    if @message.save
      ChatChannel.broadcast_to(
        @chat_room,
        message: render_message(@message)
      )
      render json: { status: "success" }, status: :created
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def render_message(message)
    ApplicationController.renderer.render(
      partial: "messages/message",
      locals: {
        message: message,
        user: message.sender.is_a?(User) ? message.sender : nil
      }
    )
  end
end
