# frozen_string_literal: true

module RequestItemHelper
  def render_request?(document)
    (!is_ned_item?(document) || has_online_copy?(document)) &&
      !is_electronic_resource?(document)
  end

  def has_online_copy?(document)
    document.copy_access.present? && document.copy_access.first[:href].include?("nla.gov.au")
  end

  def has_online_access?(document)
    document.online_access.present? && document.online_access.first[:href].include?("nla.gov.au")
  end
  alias_method :is_ned_item?, :has_online_access?

  def is_electronic_resource?(document)
    callnumber = document.fetch("call_number_tsim")
    callnumber.include?("ELECTRONIC RESOURCE") || callnumber.include?("INTERNET")
  rescue
    false
  end
end
