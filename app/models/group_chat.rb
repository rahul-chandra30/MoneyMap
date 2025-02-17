class GroupChat < ApplicationRecord
  has_many :group_messages, dependent: :destroy
end
