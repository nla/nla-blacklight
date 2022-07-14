class AddPatronFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    # remove unnecessary columns and indices

    remove_index :users, :email
    remove_index :users, :reset_password_token

    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at

    # new columns

    rename_column :users, :email, :barcode
    rename_column :users, :encrypted_password, :family_name
    add_column :users, :patron_id, :bigint
    add_column :users, :voyager_id, :bigint

    add_index :users, :patron_id, unique: true
    add_index :users, :voyager_id, unique: true
  end
end
