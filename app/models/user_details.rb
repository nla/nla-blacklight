# frozen_string_literal: true

require "benchmark"

class UserDetails
  include ActiveModel::Model

  # order of attributes in ALL_ATTRIBUTES array determines order in view
  ALL_ATTRIBUTES = %w[first_name last_name email phone mobile_phone password postcode]

  PATRON_ATTRIBUTES = %w[first_name last_name email phone mobile_phone password postcode]
  PATRON_EDITABLE_ATTRIBUTES = %w[email phone mobile_phone password postcode]

  STAFF_ATTRIBUTES = %w[first_name last_name email]
  STAFF_EDITABLE_ATTRIBUTES = []

  PATRON_PROVIDER = "catalogue_patron"

  attr_reader :last_name, :first_name, :email, :phone, :mobile_phone, :postcode

  def initialize(folio_details)
    @first_name = folio_details.dig("personal", "firstName")
    @last_name = folio_details.dig("personal", "lastName")
    @email = folio_details.dig("personal", "email")
    @phone = folio_details.dig("personal", "phone")
    @mobile_phone = folio_details.dig("personal", "mobilePhone")
    @postcode = folio_details.dig("personal", "addresses")&.first&.[]("postalCode")
  end
end
