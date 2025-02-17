class GroupChatsController < ApplicationController
  before_action :authenticate_user!

  def show
  puts "PARAMS: #{params.inspect}" # Debugging line
  @group_chat = GroupChat.find_by(name: params[:name])
  @messages = @group_chat.group_messages.order(created_at: :asc)
  end
end