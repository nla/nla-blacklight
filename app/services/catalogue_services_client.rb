# frozen_string_literal: true

class ServiceTokenError < StandardError; end

class HoldingsRequestError < StandardError; end

class ItemRequestError < StandardError; end

class CatalogueServicesClient
  MAX_TOKEN_RETRIES = 3

  # rubocop:disable Lint/SymbolConversion
  DEFAULT_REQUEST_SUMMARY = {
    "readyForCollection": [],
    "itemsRequested": [],
    "notAvailable": [],
    "previousRequests": [],
    "numRequestsRemaining": 999
  }
  # rubocop:enable Lint/SymbolConversion

  def get_request_summary(folio_id:)
    conn = Faraday.new(url: ENV["CATALOGUE_SERVICES_API_BASE_URL"]) do |f|
      f.response :json
    end

    res = conn.get("/catalogue-services/folio/user/#{folio_id}/myRequests")
    if res.status == 200
      res.body.presence || DEFAULT_REQUEST_SUMMARY
    else
      Rails.logger.error "Failed to retrieve request summary for #{folio_id}"
      DEFAULT_REQUEST_SUMMARY
    end
  rescue => e
    Rails.logger.error "get_request_summary - Failed to connect catalogue-service: #{e.message}"
    DEFAULT_REQUEST_SUMMARY
  end

  def get_holdings(instance_id:)
    conn = Faraday.new(url: ENV["CATALOGUE_SERVICES_API_BASE_URL"]) do |f|
      f.response :json
    end

    res = conn.get("/catalogue-services/folio/instance/#{instance_id}")
    if res.status == 200
      if res.body.present?
        res.body["holdingsRecords"]
      end
    else
      Rails.logger.error "Failed to retrieve holdings for #{instance_id}"
      raise HoldingsRequestError.new("Failed to retrieve holdings for #{instance_id}")
    end
  rescue => e
    Rails.logger.error "get_holdings - Failed to connect catalogue-service: #{e.message}"
    raise HoldingsRequestError.new("Failed to retrieve holdings for #{instance_id}")
  end

  def get_holding(instance_id:, holdings_id:, item_id:)
    all_holdings = get_holdings(instance_id: instance_id)

    # find holdings record
    holding = all_holdings.find { |h| h["id"] == holdings_id }

    # find item record
    item = holding["itemRecords"].find { |i| i["id"] == item_id }

    [holding, item]
  end

  def create_request(requester:, request:)
    conn = Faraday.new(url: ENV["CATALOGUE_SERVICES_API_BASE_URL"]) do |f|
      f.response :json
    end

    request_body = JSON.generate(requesterId: requester,
      instanceId: request[:instance_id],
      holdingsId: request[:holdings_id],
      itemId: request[:item_id],
      yearCaption: [request[:year]],
      enumeration: request[:enumeration],
      chronology: request[:chronology],
      patronComments: request[:notes])
    res = conn.post("/catalogue-services/folio/request/new") do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = request_body
    end
    if res.status == 200
      (res.body.presence || {})
    else
      message = "Failed to request item (#{request[:item_id]}) for requester (#{requester})"
      Rails.logger.error message
      raise ItemRequestError.new(message)
    end
  rescue => e
    Rails.logger.error "create_request - Failed to connect catalogue-service: #{e.message}"
    raise ItemRequestError.new("Failed to request item (#{request[:item_id]}) for requester (#{requester})")
  end

  def request_limit_reached?(requester:)
    conn = Faraday.new(url: ENV["CATALOGUE_SERVICES_API_BASE_URL"]) do |f|
      f.response :json
    end

    res = conn.get("/catalogue-services/folio/user/#{requester}/requestLimitReached")
    if res.status == 200
      res.body["requestLimitReached"].to_s.casecmp("true").zero?
    else
      message = "Failed to check request limit for requester (#{requester})"
      Rails.logger.error message

      # Raise an ItemRequestError, since if we're unable to check the user's request limit, the
      # user will likely be unable to request items also (i.e. their account is broken).
      raise ItemRequestError.new(message)
    end
  rescue => e
    Rails.logger.error "request_limit_reached? - Failed to connect catalogue-service: #{e.message}"
    raise ItemRequestError.new("Failed to check request limit for requester (#{requester})")
  end
end
