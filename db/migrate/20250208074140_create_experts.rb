class CreateExperts < ActiveRecord::Migration[8.0]
  def change
    create_table :experts do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :phone

      t.timestamps
    end
  end
end
