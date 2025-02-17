class CreateGroupMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :group_messages do |t|
      t.references :group_chat, null: false, foreign_key: true
      t.references :sender, polymorphic: true, null: false
      t.text :content

      t.timestamps
    end
  end
end
