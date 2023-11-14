class CreateChatRoomMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_room_members do |t|
      t.references :room, index:true, null: false, foreign_key: {to_table: :chat_rooms}
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
