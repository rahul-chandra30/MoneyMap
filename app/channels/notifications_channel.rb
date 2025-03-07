# app/channels/notifications_channel.rb
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    user = connection.current_user_or_expert
    stream_from "notifications_channel_#{user.id}"
    Rails.logger.info "#{user.class} #{user.id} subscribed to notifications!"
  end

  def unsubscribed
    stop_all_streams
    Rails.logger.info "User unsubscribed from notifications!"
  end
end