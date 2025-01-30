class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.string :user_id, primary_key: true
      t.string :name
      t.string :email
      t.string :password
      t.string :phone

      t.timestamps
    end
  end
end