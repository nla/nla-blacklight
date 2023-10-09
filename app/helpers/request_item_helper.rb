# frozen_string_literal: true

module RequestItemHelper
  def render_request?(document)
    (!is_ned_item?(document) || has_online_copy?(document)) &&
      !is_electronic_resource?(document)
  end

  def has_online_copy?(document)
    document.copy_access_urls.present? && document.copy_access_urls.first[:href].include?("nla.gov.au")
  end

  def has_online_access?(document)
    document.online_access_urls.present? && document.online_access_urls.first[:href].include?("nla.gov.au")
  end

  def is_ned_item?(document)
    document.system_control_number.present? &&
      document.system_control_number.any? { |control_number| control_number.include?("(AU-CaNED)") }
  end

  def is_electronic_resource?(document)
    document.callnumber.include?("ELECTRONIC RESOURCE") || document.callnumber.include?("INTERNET")
  rescue
    false
  end
end
