module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_sender

    def connect
      self.current_sender = find_verified_sender
      logger.add_tags 'ActionCable', current_sender.name
    end

    private

    def find_verified_sender
      if verified_user = User.find_by(id: cookies.encrypted[:user_id]) ||
                        Expert.find_by(id: cookies.encrypted[:expert_id])
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end