# frozen_string_literal: true

module RequestItemHelper
  def has_online_copy?(document)
    document.copy_access.present? && document.copy_access.first[:href].include?("nla.gov.au")
  end

  def has_online_access?(document)
    document.online_access.present? && document.online_access.first[:href].include?("nla.gov.au")
  end
  alias_method :is_ned_item?, :has_online_access?
end
