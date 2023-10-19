# frozen_string_literal: true

class UserDetails
  include ActiveModel::Model

  EDITABLE_ATTRIBUTES = %w[first_name last_name email password phone mobile_phone post_code]
  PATRON_EDITABLE_ATTRIBUTES = %w[email password phone mobile_phone post_code]

  attr_reader :last_name, :first_name, :email, :phone, :mobile_phone, :post_code

  def initialize(folio_details, current_user)
    @last_name = current_user.name_given
    @first_name = current_user.name_family
    @email = current_user.email
    @phone = folio_details.personal&.phone
    @mobile_phone = folio_details.personal&.mobilePhone
    @post_code = folio_details.personal&.addresses&.first&.postalCode
  end
end
