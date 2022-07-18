class CreatePatronDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :patron_details do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name_family
      t.string :name_given
      t.string :address_line1
      t.string :address_line2
      t.string :address_locality
      t.string :address_postcode
      t.string :address_state
      t.string :address_country
      t.string :email
      t.string :phone
      t.string :mobile
      t.string :barcode
      t.string :reg_status
      t.string :catalogue_group_code
      t.date :expiry_date
      t.string :idproof
      t.string :photocopy_card_id
      t.text :comments
      t.text :rejection_reason
      t.text :research_interests

      t.timestamps
    end
  end
end
