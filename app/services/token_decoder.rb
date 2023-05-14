# frozen_string_literal: true

require "json/jwt"

class NotRegisteredError < StandardError; end

class TokenDecoder
  def initialize(token, aud)
    @token = token
    @aud = aud
    @iss = "#{ENV["KEYCLOAK_URL"]}/auth/realms/#{ENV["CATALOGUE_SERVICES_REALM"]}"
  end

  def decode
    @certs_endpoint = "#{ENV["KEYCLOAK_URL"]}/auth/realms/#{ENV["CATALOGUE_SERVICES_REALM"]}/protocol/openid-connect/certs"

    certs = Faraday.get @certs_endpoint
    if certs.status == 200
      json = JSON.parse(certs.body)
      @certs = json["keys"]
      Rails.logger.debug "Successfully got certificate. Certificate length: #{@certs.length}"
    else
      message = "Couldn't get certificate. URL: #{@certs_endpoint}"
      Rails.logger.error message
    end

    jwks = JSON::JWK::Set.new(@certs)
    JSON::JWT.decode @token, jwks
  end
end
