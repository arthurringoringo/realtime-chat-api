class ChatRoom < ApplicationRecord
  belongs_to :created_by, class_name: "User"
  has_many :messages
  has_many :chat_room_members, foreign_key: "room_id", dependent: :destroy
  after_create :create_creator_member
  validates :name, presence: true

  def create_creator_member
    chat_room_members.create!(user: self.created_by)
  end
end
