class CreateChatRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_rooms do |t|
      t.string :name
      t.references :created_by, index:true,  null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
