module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_sender

    def connect
      self.current_sender = find_verified_sender
    end

    private

    def find_verified_sender
      user = User.find_by(id: session['user_id'])
      expert = Expert.find_by(id: session['expert_id'])
      
      if user || expert
        user || expert
      else
        reject_unauthorized_connection
      end
    end

    def session
      @session ||= cookies.encrypted[Rails.application.config.session_options[:key]]
    end
  end
end
