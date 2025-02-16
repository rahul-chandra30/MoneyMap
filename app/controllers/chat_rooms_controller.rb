class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

def index
  if current_user
    puts "Current user: #{current_user.name}" # Debugging line
    @chat_partners = Expert.all
    @chat_rooms = current_user.chat_rooms.includes(:expert, :messages).order(updated_at: :desc)
  elsif current_expert
    puts "Current expert: #{current_expert.name}" # Debugging line
    @chat_partners = User.all
    @chat_rooms = current_expert.chat_rooms.includes(:user, :messages).order(updated_at: :desc)
  else
    redirect_to root_path, alert: "Please sign in to access this page."
  end
end


  def show
    @chat_room = ChatRoom.includes(:messages).find(params[:id])
    @messages = @chat_room.messages.order(created_at: :asc)
  end
end