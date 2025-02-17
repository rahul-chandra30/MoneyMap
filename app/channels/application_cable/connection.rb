module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user_or_expert

    def connect
      self.current_user_or_expert = find_verified_user
      logger.info "Connected as #{current_user_or_expert.class} #{current_user_or_expert.id}"
    end

    private

    def find_verified_user
      if verified_user = User.find_by(id: cookies.signed[:user_id]) ||
                        Expert.find_by(id: cookies.signed[:expert_id])
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end