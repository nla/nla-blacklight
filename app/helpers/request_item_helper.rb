# frozen_string_literal: true

module RequestItemHelper
  ELECTRONIC_RESOURCE_CALL_NUMBERS = ["ELECTRONIC RESOURCE", "INTERNET"].freeze

  DFL_ENABLED = ENV["DFL_ENABLED"] == "true"
  DFL_LOAN_TYPE = "DFL"
  DFL_LEGACY_LOAN_TYPE_IDS = %w[ee559791-b8c8-40fa-be8b-ab2ae6c2fe82 f6736b0d-0fa5-444f-b6f3-524f5f860437].freeze

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

  def is_dfl_item?(item)
    return false unless DFL_ENABLED

    dfl_item_metadata?(item)
  end

  def is_dfl_for_document?(document)
    return false unless DFL_ENABLED

    instance_id = document.first("folio_instance_id_ssim")
    return false unless instance_id

    all_holdings = CatalogueServicesClient.new.get_holdings(instance_id: instance_id)
    result = all_holdings.any? do |holding|
      holding["itemRecords"].any? { |item| dfl_item_metadata?(item) }
    end
    Rails.logger.info "DFL document: instance_id=#{instance_id}, result=#{result}"
    result
  rescue HoldingsRequestError, ServiceTokenError, StandardError => e
    Rails.logger.error "DFL document check error: #{e.message}"
    false
  end

  def dfl_item_metadata?(item)
    return item["loanType"] == DFL_LOAN_TYPE if item["loanType"].present?

    DFL_LEGACY_LOAN_TYPE_IDS.include?(item["permanentLoanTypeId"])
  end
end
