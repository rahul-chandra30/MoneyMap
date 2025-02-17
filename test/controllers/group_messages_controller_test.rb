require "test_helper"

class GroupMessagesControllerTest < ActionDispatch::IntegrationTest
  before_action :authenticate_user!

  def create
    @group_chat = GroupChat.find_by(name: params[:group_chat_name])
    @message = @group_chat.group_messages.new(message_params)
    @message.sender = current_user || current_expert

    if @message.save
      ActionCable.server.broadcast("group_chat_#{@group_chat.name}", {
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
    params.require(:group_message).permit(:content)
  end
end
