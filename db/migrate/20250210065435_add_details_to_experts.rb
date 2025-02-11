class AddDetailsToExperts < ActiveRecord::Migration[7.0]
  def change
    add_column :experts, :age, :integer
    add_column :experts, :gender, :string
    add_column :experts, :experience, :integer
    add_column :experts, :about, :text
    add_column :experts, :charges_per_session, :decimal, precision: 10, scale: 2
  end
end