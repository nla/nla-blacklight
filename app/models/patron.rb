class Patron
  include ActiveModel::Model

  attr_accessor :name_family, :name_given
  attr_accessor :address_line1, :address_line2, :address_locality, :address_postcode, :address_state, :address_country
  attr_accessor :email, :phone, :mobile
  attr_accessor :barcode, :reg_status, :catalogue_group_code, :expiry_date, :idproof, :photocopy_card_id
  attr_accessor :comments, :rejection_reason, :research_interests
end
