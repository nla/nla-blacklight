class AddPatronFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_id, :string
    add_column :users, :family_name, :string
    add_column :users, :patron_id, :integer
    add_column :users, :voyager_id, :integer
  end
end
