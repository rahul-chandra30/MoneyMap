class GroupChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "group_chat_#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end