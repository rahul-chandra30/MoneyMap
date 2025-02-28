# app/channels/chatbot_channel.rb
require 'open3'

class ChatbotChannel < ApplicationCable::Channel
  def subscribed
    user = connection.current_user
    unless user
      Rails.logger.info "No user found, can’t chat!"
      reject
      return
    end
    Rails.logger.info "User #{user.id} joined the chatbot!"
    stream_from "chatbot_channel_#{user.id}"
  end

  def unsubscribed
    user = connection.current_user
    return unless user
    Rails.logger.info "User #{user.id} left the chatbot!"
    stop_all_streams
  end

  def receive(data)
    user = connection.current_user
    unless user
      Rails.logger.info "No user, can’t answer!"
      return
    end
    question = data["message"]
    Rails.logger.info "User #{user.id} asked: #{question}"

    python_path = "/Users/rahul/MoneyMap/moneymap/chatbot_env/bin/python3"
    script_path = "/Users/rahul/MoneyMap/moneymap/chatbot/chatbot_logic.py"
    begin
      cmd = "#{python_path} #{script_path} \"#{question.gsub('"', '\"')}\" #{user.id}"
      stdout, stderr, status = Open3.capture3(cmd)
      if status.success?
        Rails.logger.info "Python stdout: #{stdout}"
        Rails.logger.error "Python stderr: #{stderr}" unless stderr.empty?
        answer = stdout.strip
      else
        Rails.logger.error "Python script failed: #{stderr}"
        answer = "Error: Chatbot failed - check logs"
      end
    rescue Errno::ENOENT => e
      Rails.logger.error "Python script error: #{e.message}"
      answer = "Error: Chatbot script not found"
    end
    message = { content: answer, sender: 'Budget Bot 🤖' }

    ActionCable.server.broadcast("chatbot_channel_#{user.id}", message)
    Rails.logger.info "Sent answer to user #{user.id}: #{message[:content]}"
  end
end