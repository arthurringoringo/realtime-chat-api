class User < ApplicationRecord
  has_many :chat_rooms
  has_many :chat_room_members, foreign_key: :user_id
  has_many :messages
end
