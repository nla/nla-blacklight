# frozen_string_literal: true

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
