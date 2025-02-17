class ChatRoomsController < ApplicationController
  before_action :authenticate_user!, only: :user_chat
  before_action :authenticate_expert!, only: :expert_chat
  layout 'chat'

  def user_chat
    @chat_rooms = ChatRoom.where(user: current_user).includes(:expert)
    @available_experts = Expert.all
    render 'chat_rooms/user_chat'
  end

  def expert_chat
    @chat_rooms = ChatRoom.where(expert: current_expert).includes(:user)
    render 'chat_rooms/expert_chat'
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @messages = @chat_room.messages.includes(:sender).order(created_at: :asc)
    @message = Message.new
  end

  def create
    @chat_room = ChatRoom.new(chat_room_params)
    
    if @chat_room.save
      redirect_to chat_room_path(@chat_room)
    else
      redirect_to chat_rooms_path, alert: 'Unable to create chat room'
    end
  end

  private

  def chat_room_params
    params.require(:chat_room).permit(:expert_id).merge(user_id: current_user.id)
  end
end