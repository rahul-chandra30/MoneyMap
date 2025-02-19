class RestructureTablesForActionCable < ActiveRecord::Migration[8.0]
  def change
    # Drop existing foreign keys
    remove_foreign_key :bookings, :users
    remove_foreign_key :chat_rooms, :users
    remove_foreign_key :expenditures, :users
    remove_foreign_key :expenses, :users

    # Change users table
    rename_table :users, :users_old
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :phone
      t.timestamps
    end

    # Copy data from old users table
    execute <<-SQL
      INSERT INTO users (id, name, email, password_digest, phone, created_at, updated_at)
      SELECT user_id, name, email, password_digest, phone, created_at, updated_at
      FROM users_old;
    SQL

    drop_table :users_old

    # Re-add foreign keys
    add_foreign_key :bookings, :users
    add_foreign_key :chat_rooms, :users
    add_foreign_key :expenditures, :users
    add_foreign_key :expenses, :users
  end
end