module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user_or_expert

    def connect
      self.current_user_or_expert = find_verified_user
      logger.add_tags "ActionCable", "#{current_user_or_expert.class} #{current_user_or_expert.id}"
    end

    def disconnect
      Rails.logger.debug "Client disconnected: #{current_user_or_expert.class} #{current_user_or_expert.id}"
    end

    private

    def find_verified_user
      if (user_id = cookies.signed[:user_id])
        User.find_by(id: user_id)
      elsif (expert_id = cookies.signed[:expert_id])
        Expert.find_by(id: expert_id)
      else
        reject_unauthorized_connection
      end
    end
  end
end
