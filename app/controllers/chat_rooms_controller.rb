class ChatRoomsController < ApplicationController
  before_action :authenticate_user_or_expert!

  def user_chat
    @experts = Expert.all
  end

  def expert_chat
    @users = User.all
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @messages = @chat_room.messages.includes(:sender).order(created_at: :asc)

    unless @chat_room.user == current_user || @chat_room.expert == current_expert
      flash[:alert] = "You don't have permission to access this chat room."
      redirect_to root_path
    end
  end

  def create_or_find


    if current_user
      @expert = Expert.find(params[:expert_id])
      @chat_room = ChatRoom.find_or_create_by!(user: current_user, expert: @expert)
    elsif current_expert
      @user = User.find(params[:user_id])
      @chat_room = ChatRoom.find_or_create_by!(user: @user, expert: current_expert)
    end

    @messages = @chat_room.messages.last(20)
    messages_html = render_to_string(
    partial: "messages/message",
    collection: @messages,
    locals: { user: current_user },
    formats: [:html]
    )

    render json: {
      chat_room_id: @chat_room.id,
      messages: render_to_string(
        partial: 'messages/message', 
        collection: @messages,
        formats: [:html]
      )
    }
  rescue => e
    Rails.logger.error "Error in create_or_find: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
