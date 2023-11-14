class User < ApplicationRecord
  has_many :chat_rooms
  has_many :messages
end
