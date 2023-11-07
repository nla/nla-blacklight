# frozen_string_literal: true

module RequestItemHelper
  def render_request?(document)
    !is_ned_item?(document) && !has_no_physical_holdings?(document)
  end

  def has_online_copy?(document)
    document.copy_access.present? && document.copy_access.first[:href].include?("nla.gov.au")
  end

  def has_online_access?(document)
    document.online_access.present? && document.online_access.first[:href].include?("nla.gov.au")
  end

  def is_ned_item?(document)
    document.system_control_number.present? &&
      document.system_control_number.any? { |control_number| control_number.include?("(AU-CaNED)") }
  end

  def is_electronic_resource?(document)
    callnumber = document.fetch("call_number_tsim")
    callnumber.include?("ELECTRONIC RESOURCE") || callnumber.include?("INTERNET")
  rescue
    false
  end

  def has_no_physical_holdings?(document)
    callnumber = document.fetch("call_number_tsim")
    (callnumber.include?("ELECTRONIC RESOURCE") || callnumber.include?("INTERNET")) && callnumber.length == 1
  rescue
    false
  end
end
