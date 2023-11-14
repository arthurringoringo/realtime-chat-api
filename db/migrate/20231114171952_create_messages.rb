class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :text
      t.references :room,index: true, null: false, foreign_key:{to_table: :chat_rooms}
      t.references :sender,index: true, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
