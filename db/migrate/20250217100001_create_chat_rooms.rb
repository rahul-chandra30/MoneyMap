class CreateChatRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_rooms do |t|
      t.references :user, null: false, foreign_key: { to_table: :users, primary_key: :user_id }
      t.references :expert, null: false, foreign_key: true
      t.timestamps
    end
  end
end