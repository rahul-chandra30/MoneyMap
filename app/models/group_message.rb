class GroupMessage < ApplicationRecord
  belongs_to :group_chat
  belongs_to :sender, polymorphic: true
end
