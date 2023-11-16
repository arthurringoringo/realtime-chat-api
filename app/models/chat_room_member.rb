class ChatRoomMember < ApplicationRecord
  belongs_to :room, class_name: "ChatRoom", foreign_key: :room_id
  belongs_to :user, class_name: "User", foreign_key: :user_id
end
