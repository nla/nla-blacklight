class AddFolioId < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :folio_id, :string, :after => :id
  end
end
