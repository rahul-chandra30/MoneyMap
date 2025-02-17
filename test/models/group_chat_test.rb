require "test_helper"

class GroupChatTest < ActiveSupport::TestCase
  has_many :group_messages, dependent: :destroy
end
