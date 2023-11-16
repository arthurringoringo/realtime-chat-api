class Message < ApplicationRecord
  belongs_to :chat_room, class_name: "ChatRoom", foreign_key: :room_id
  belongs_to :sender, class_name: "User", foreign_key: :sender_id
end
