class AddPatronFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    # remove unnecessary columns and indices

    remove_index :users, :email
    remove_index :users, :reset_password_token

    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at

    # new columns
    add_column :users, :patron_id, :bigint, :after => :id, null: false
    add_column :users, :voyager_id, :bigint, :after => :patron_id, null: false
    add_column :users, :name_given, :string, :after => :voyager_id
    add_column :users, :name_family, :string, :after => :name_given

    add_index :users, :patron_id, unique: true
    add_index :users, :voyager_id, unique: true
  end
end
