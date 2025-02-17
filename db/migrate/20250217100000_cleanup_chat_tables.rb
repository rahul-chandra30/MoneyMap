class CleanupChatTables < ActiveRecord::Migration[7.0]
  def up
    # First drop messages table because it depends on chat_rooms
    drop_table :messages if table_exists?(:messages)
    
    # Then drop chat_rooms table
    drop_table :chat_rooms if table_exists?(:chat_rooms)
  end

  def down
    # No down migration needed as we're recreating these tables
    raise ActiveRecord::IrreversibleMigration
  end
end