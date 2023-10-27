# frozen_string_literal: true

require "email_validator"

class UserDetails
  include ActiveModel::Model
  include ActiveModel::Serialization

  validates :email, presence: true, email: {mode: :strict, require_fqdn: true}

  # order of attributes in ALL_ATTRIBUTES array determines order in view
  ALL_ATTRIBUTES = %w[first_name last_name email phone mobile_phone password postcode]

  PATRON_ATTRIBUTES = %w[first_name last_name email phone mobile_phone password postcode]
  PATRON_EDITABLE_ATTRIBUTES = %w[email phone mobile_phone password postcode]

  STAFF_ATTRIBUTES = %w[first_name last_name email]
  STAFF_EDITABLE_ATTRIBUTES = []

  PATRON_PROVIDER = "catalogue_patron"

  attr_accessor :last_name, :first_name, :email, :phone, :mobile_phone, :postcode

  def attributes
    {
      "last_name" => last_name,
      "first_name" => first_name,
      "email" => email,
      "phone" => phone,
      "mobile_phone" => mobile_phone,
      "postcode" => postcode
    }
  end
end
