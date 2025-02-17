class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :chat_room, null: false, foreign_key: true
      t.references :sender, polymorphic: true, null: false
      t.text :content, null: false
      t.timestamps
    end
  end
end