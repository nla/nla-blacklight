# This migration comes from catalogue_patrons_engine (originally 20230117045047)
class AddSessionsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id, :unique => true
    add_index :sessions, :updated_at
  end
end
