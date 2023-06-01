# frozen_string_literal: true

class ServiceTokenError < StandardError; end

class HoldingsRequestError < StandardError; end

class ItemRequestError < StandardError; end

class CatalogueServicesClient
  MAX_TOKEN_RETRIES = 3

  def initialize
    @oauth_client ||= init_client
  end

  def get_holdings(instance_id:)
    conn = Faraday.new(url: ENV["CATALOGUE_SERVICES_API_BASE_URL"]) do |f|
      f.request :authorization, "Bearer", bearer_token.token
      f.response :json
    end

    res = conn.get("/catalogue-services/folio/instance/#{instance_id}")
    if res.status == 200
      if res.body.present?
        res.body["holdingsRecords"]
      else
        []
      end
    else
      Rails.logger.error "Failed to retrieve holdings for #{instance_id}"
      raise HoldingsRequestError.new("Failed to retrieve holdings for #{instance_id}")
    end
  end

  def get_holding(instance_id:, holdings_id:, item_id:)
    all_holdings = get_holdings(instance_id: instance_id)

    # find holdings record
    holding = all_holdings.select { |h| h["id"] == holdings_id }.first

    # find item record
    item = holding["itemRecords"].select { |i| i["id"] == item_id }.first

    [holding, item]
  end

  def create_request(requester:, request:)
    conn = Faraday.new(url: ENV["CATALOGUE_SERVICES_API_BASE_URL"]) do |f|
      f.request :authorization, "Bearer", bearer_token.token
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
  end

  private

  def bearer_token(attempt = 0)
    # check if we've tried too many times
    if attempt > MAX_TOKEN_RETRIES
      Rails.logger.error("Failed to authenticate with catalogue services. Tried #{attempt} times.")
      raise ServiceTokenError.new("Failed to authenticate with catalogue services.")
    end

    # If there is no cached access token, retrieve one
    # We store the object as a JSON string and rehydrate it later because some objects will
    # not serialize well.
    token_string = Rails.cache.fetch("catalogue_services_bearer_token", expires_in: 15.minutes) do
      response = get_token
      response.to_json.to_s
    end

    @bearer_token = OAuth2::AccessToken.from_hash(@oauth_client, JSON.parse(token_string))

    # if the cached access token is expired, retrieve a new one
    if @bearer_token.expired?
      # delete the cached token, to make sure we get a new one
      Rails.cache.delete("catalogue_services_bearer_token")

      @bearer_token = bearer_token(attempt + 1)
    end

    @bearer_token
  end

  def get_token
    @oauth_client.client_credentials.get_token
  rescue
    message = "Failed to authenticate with catalogue services."
    Rails.logger.error message
    raise ServiceTokenError.new(message)
  end

  def init_client
    site = "#{ENV["KEYCLOAK_URL"]}/auth/realms/#{ENV["CATALOGUE_SERVICES_REALM"]}/.well-known/openid-configuration"
    OAuth2::Client.new(ENV["CATALOGUE_SERVICES_CLIENT"], ENV["CATALOGUE_SERVICES_SECRET"],
      site: site,
      authorize_url: "/auth/realms/#{ENV["CATALOGUE_SERVICES_REALM"]}/protocol/openid-connect/auth",
      token_url: "/auth/realms/#{ENV["CATALOGUE_SERVICES_REALM"]}/protocol/openid-connect/token")
  end
end
