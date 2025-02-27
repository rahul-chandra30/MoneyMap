# app/channels/chatbot_channel.rb
class ChatbotChannel < ApplicationCable::Channel
  def subscribed
    # Make sure we have a user (not an expert)
    user = connection.current_user
    unless user
      Rails.logger.info "No user found, can’t chat!"
      reject
      return
    end
    # Start the chat room for this user
    Rails.logger.info "User #{user.id} joined the chatbot!"
    stream_from "chatbot_channel_#{user.id}"
  end

  def unsubscribed
    # Say goodbye when they leave
    user = connection.current_user
    return unless user
    Rails.logger.info "User #{user.id} left the chatbot!"
    stop_all_streams
  end

  def receive(data)
    # Get the user and question
    user = connection.current_user
    unless user
      Rails.logger.info "No user, can’t answer!"
      return
    end
    question = data["message"]
    Rails.logger.info "User #{user.id} asked: #{question}"

    # Call Python script and get only the returned answer
    python_path = "/Users/rahul/MoneyMap/moneymap/chatbot_env/bin/python3"
    script_path = "/Users/rahul/MoneyMap/moneymap/chatbot/groq_connector.py"
    result = `#{python_path} #{script_path} "#{question}" #{user.id}`.strip
    answer = result.lines.last.strip  # Get only the last line (the return value)
    message = { content: answer, sender: 'Budget Bot 🤖' }

    # Send the clean answer to the chat
    ActionCable.server.broadcast("chatbot_channel_#{user.id}", message)
    Rails.logger.info "Sent answer to user #{user.id}: #{message[:content]}"
  end
end