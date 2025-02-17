require "test_helper"

class GroupMessageTest < ActiveSupport::TestCase
    belongs_to :group_chat
    belongs_to :sender, polymorphic: true
end
