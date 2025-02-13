class AddDesignationToExperts < ActiveRecord::Migration[7.0]
  def change
    add_column :experts, :designation, :string
  end
end