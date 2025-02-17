class MessagesController < ApplicationController
  before_action :authenticate_user_or_expert!

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages.new(message_params)
    @message.sender = current_user || current_expert

    respond_to do |format|
      if @message.save
        ChatChannel.broadcast_to @chat_room, {
          message: render_to_string(
            partial: 'messages/message',
            locals: { message: @message },
            formats: [:html]
          )
        }
        
        format.html { redirect_to @chat_room }
        format.js   # This will render create.js.erb
        format.json { render json: { success: true }, status: :ok }
      else
        format.html { redirect_to @chat_room, alert: @message.errors.full_messages.join(', ') }
        format.js   { render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity }
        format.json { render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end