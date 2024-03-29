# frozen_string_literal: true

class UserDetails
  include ActiveModel::Model
  include ActiveModel::Serialization

  validates :email, presence: true, if: -> { validation_context == :email }
  validates :email, email: {mode: :strict, require_fqdn: true}, if: -> { validation_context == :email && email.present? }
  validates :phone, phone: {allow_blank: true}, if: -> { validation_context == :phone }
  validates :mobile_phone, phone: {allow_blank: true, types: [:mobile]}, if: -> { validation_context == :mobile_phone }
  validate :any_phone, if: -> { validation_context == :phone || validation_context == :mobile_phone }
  validates :postcode, presence: true, if: -> { validation_context == :postcode }

  # order of attributes in ALL_ATTRIBUTES array determines order in view
  ALL_ATTRIBUTES = %w[first_name last_name email mobile_phone phone password postcode]

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

  def any_phone
    if phone.blank? && mobile_phone.blank?
      errors.add(:base, :mobile_phone_or_phone_blank, message: I18n.t("account.settings.update.errors.any_phone"))
    end
  end
end
