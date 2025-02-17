require "test_helper"

class GroupChatsControllerTest < ActionDispatch::IntegrationTest
  before_action :authenticate_user!

  def show
    @group_chat = GroupChat.find_by(name: params[:name])
    @messages = @group_chat.group_messages.order(created_at: :asc)
  end
end
