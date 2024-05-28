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
  ALL_ATTRIBUTES = %w[first_name last_name email mobile_phone phone password postcode email_2fa]

  PATRON_ATTRIBUTES = %w[first_name last_name email phone mobile_phone password postcode email_2fa]
  PATRON_EDITABLE_ATTRIBUTES = %w[email phone mobile_phone password postcode email_2fa]

  STAFF_ATTRIBUTES = %w[first_name last_name email]
  STAFF_EDITABLE_ATTRIBUTES = []

  PATRON_PROVIDER = "catalogue_patron"

  attr_accessor :last_name, :first_name, :email, :phone, :mobile_phone, :postcode, :email_2fa

  def initialize(folio_details = {}, email_2fa = "false")
    @last_name = folio_details[:last_name]
    @first_name = folio_details[:first_name]
    @email = folio_details[:email]
    @phone = folio_details[:phone]
    @mobile_phone = folio_details[:mobile_phone]
    @postcode = folio_details[:postcode]
    @email_2fa = ActiveModel::Type::Boolean.new.cast(email_2fa)
  end

  def attributes
    {
      last_name: last_name,
      first_name: first_name,
      email: email,
      phone: phone,
      mobile_phone: mobile_phone,
      postcode: postcode,
      email_2fa: email_2fa
    }
  end

  def any_phone
    if phone.blank? && mobile_phone.blank?
      errors.add(:base, :mobile_phone_or_phone_blank, message: I18n.t("account.settings.update.errors.any_phone"))
    end
  end
end
