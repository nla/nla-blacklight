# frozen_string_literal: true

module RequestItemHelper
  ELECTRONIC_RESOURCE_CALL_NUMBERS = ["ELECTRONIC RESOURCE", "INTERNET"].freeze

  def render_request?(document)
    return false if ENV["FOLIO_UPDATE_IN_PROGRESS"] == "true"
    !is_ned_item?(document) && !has_no_physical_holdings?(document)
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
    document.callnumber.any? { |n| ELECTRONIC_RESOURCE_CALL_NUMBERS.include? n }
  rescue
    false
  end

  def has_no_physical_holdings?(document)
    is_electronic_resource?(document) && document.callnumber.length == 1
  rescue
    false
  end
end
