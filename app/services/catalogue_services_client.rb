# frozen_string_literal: true

class ItemRequestError < StandardError; end

class CatalogueServicesClient
  def initialize
    @oauth_client ||= init_client
  end

  def get_holdings(instance_id:)
    set_token
    conn = Faraday.new(url: ENV["CATALOGUE_SERVICES_API_BASE_URL"]) do |f|
      f.request :authorization, "Bearer", @bearer_token
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
      []
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
    set_token
    conn = Faraday.new(url: ENV["CATALOGUE_SERVICES_API_BASE_URL"]) do |f|
      f.request :authorization, "Bearer", @bearer_token
      f.response :json
    end

    request_body = JSON.generate(requesterId: requester,
      instanceId: request[:instance_id],
      holdingsId: request[:holdings_id],
      itemId: request[:item_id],
      year: [request[:year]],
      enumeration: request[:enumeration],
      chronology: request[:chronology],
      barcode: request[:barcode],
      notes: request[:notes])
    res = conn.post("/catalogue-services/folio/request/new") do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = request_body
    end
    if res.status == 200
      (res.body.presence || {})
    else
      Rails.logger.error "Failed to request #{request[:item_id]} for #{current_user}"
      throw ItemRequestError.new("Unfortunately your request could not be completed. Please try again later.")
    end
  end

  private

  def set_token
    response = @oauth_client.client_credentials.get_token
    @bearer_token = response.token
  end

  def init_client
    site = "#{ENV["KEYCLOAK_URL"]}/auth/realms/#{ENV["CATALOGUE_SERVICES_REALM"]}/.well-known/openid-configuration"
    OAuth2::Client.new(ENV["CATALOGUE_SERVICES_CLIENT"], ENV["CATALOGUE_SERVICES_SECRET"],
      site: site,
      authorize_url: "/auth/realms/#{ENV["CATALOGUE_SERVICES_REALM"]}/protocol/openid-connect/auth",
      token_url: "/auth/realms/#{ENV["CATALOGUE_SERVICES_REALM"]}/protocol/openid-connect/token")
  end

  # :nocov:
  def decode_access_token
    @certs_endpoint = "#{ENV["KEYCLOAK_URL"]}/auth/realms/#{ENV["CATALOGUE_SERVICES_REALM"]}/protocol/openid-connect/certs"

    certs = Faraday.get @certs_endpoint
    if certs.status == 200
      json = JSON.parse(certs.body)
      @certs = json["keys"]
      Rails.logger.debug { "Successfully got certificate. Certificate length: #{@certs.length}" }
    else
      message = "Couldn't get certificate. URL: #{@certs_endpoint}"
      Rails.logger.error message
      return
    end

    jwks = JSON::JWK::Set.new(@certs)
    JSON::JWT.decode @token, jwks
  end
  # :nocov:
end
