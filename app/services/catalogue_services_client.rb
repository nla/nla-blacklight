# frozen_string_literal: true

class ServiceTokenError < StandardError; end

class HoldingsRequestError < StandardError; end

class ItemRequestError < StandardError; end

class RequestDetailsError < StandardError; end

class UserDetailsError < StandardError; end

class CatalogueServicesClient
  MAX_TOKEN_RETRIES = 3

  # rubocop:disable Lint/SymbolConversion
  DEFAULT_REQUEST_SUMMARY = {
    "readyForCollection" => [],
    "itemsRequested" => [],
    "notAvailable" => [],
    "previousRequests" => [],
    "numRequestsRemaining" => 999
  }
  # rubocop:enable Lint/SymbolConversion

  def get_request_summary(folio_id:)
    conn = setup_connection

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
    conn = setup_connection

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
    conn = setup_connection

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
      res.body.presence || {}
    else
      message = "Failed to request item (#{request[:item_id]}) for requester (#{requester})"
      Rails.logger.error message
      raise ItemRequestError.new(message)
    end
  rescue => e
    Rails.logger.error "create_request - Failed to connect catalogue-service: #{e.message}"
    raise ItemRequestError.new("Failed to request item (#{request[:item_id]}) for requester (#{requester})")
  end

  def request_details(request_id:, loan: nil)
    if loan.nil?
      message = "Failed to retrieve request details for (#{request_id}) - Loan param is required"
      Rails.logger.error "request_details - #{message}"
      raise RequestDetailsError.new(message)
    end

    conn = setup_connection

    res = conn.get("/catalogue-services/folio/request/#{request_id}?loan=#{loan}")
    if res.status == 200
      JSON.parse(res.body.to_json, object_class: OpenStruct)
    else
      message = "Failed to retrieve request details for #{request_id}"
      Rails.logger.error message
      raise RequestDetailsError.new(message)
    end
  rescue => e
    Rails.logger.error "request_details - Failed to connect catalogue-service: #{e.message}"
    raise RequestDetailsError.new("Failed to retrieve request details for #{request_id}")
  end

  def request_limit_reached?(requester:)
    conn = setup_connection

    res = conn.get("/catalogue-services/folio/user/#{requester}/requestLimitReached")
    if res.status == 200
      res.body["requestLimitReached"].to_s.casecmp("true").zero?
      jbody = res.body.is_a?(String) ? JSON.parse(res.body) : res.body
      jbody["requestLimitReached"].to_s.casecmp("true").zero?
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

  def post_stats(stats)
    conn = setup_connection

    res = conn.post("/catalogue-services/log/message") do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = stats.payload
    end
    if res.status != 200
      message = "Failed to post stats to eResources stats service: #{stats.payload}"
      Rails.logger.error message
      nil
    end
  rescue
    Rails.logger.error "Failed to connect to eResources stats service: #{stats.payload}"
    nil
  end

  def user_folio_details(folio_id)
    conn = setup_connection

    res = conn.get("/catalogue-services/folio/user?query=id==#{folio_id}")
    if res.status == 200
      jbody = res.body
      if jbody.present? && jbody["totalRecords"].to_i == 1
        folio_details = jbody["users"]&.first
        {
          first_name: folio_details&.dig("personal", "firstName"),
          last_name: folio_details&.dig("personal", "lastName"),
          email: folio_details&.dig("personal", "email"),
          phone: folio_details&.dig("personal", "phone"),
          mobile_phone: folio_details&.dig("personal", "mobilePhone"),
          postcode: folio_details&.dig("personal", "addresses")&.first&.[]("postalCode")
        }
      else
        {}
      end
    else
      message = "Failed to retrieve details for #{folio_id}"
      Rails.logger.error message
      raise UserDetailsError.new(message)
    end
  rescue => e
    Rails.logger.error "user_details - Failed to connect catalogue-service: #{e.message}"
    raise UserDetailsError.new("Failed to retrieve details for #{folio_id}")
  end

  def update_user_folio_details(folio_id, params)
    conn = setup_connection

    payload = {
      folioId: folio_id
    }
    params[:user_details].each do |key, value|
      payload[key.to_s.camelize(:lower).to_sym] = value
    end

    res = conn.post("/catalogue-services/folio/user/updateDetails") do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = payload.to_json
    end
    if res.status != 200
      message = "Failed to update user details for #{folio_id} - #{res.body["status"]}: #{payload.to_json}"
      Rails.logger.error message
    end
    res.body
  rescue => e
    Rails.logger.error "update_user_folio_details - Failed to connect catalogue-service: #{e.message}"
    raise UserDetailsError.new("Failed to update details for #{folio_id}")
  end

  private

  def setup_connection
    Faraday.new(url: ENV["CATALOGUE_SERVICES_API_BASE_URL"]) do |f|
      f.response :json
    end
  end
end
