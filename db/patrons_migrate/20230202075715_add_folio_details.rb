class AddFolioDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :folio_id, :string, :after => :id
    add_column :users, :folio_ext_sys_id, :string, :after => :folio_id

    add_index :users, :folio_id, unique: true
    add_index :users, :folio_ext_sys_id, unique: true
  end
end
