# This migration comes from catalogue_patrons_engine (originally 20230117053618)
class AddOmniauthToUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :patron_id, true
    change_column_null :users, :voyager_id, true

    remove_index :users, :patron_id
    remove_index :users, :voyager_id

    add_column :users, :provider, :string, :after => :encrypted_password
    add_column :users, :uid, :string, :after => :provider
  end
end
