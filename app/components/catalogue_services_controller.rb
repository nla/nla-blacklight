# frozen_string_literal: true
class CatalogueServicesController < ApplicationController
  def initialize
    @oauth_client ||= client

    response = @oauth_client.client_credentials.get_token
    token = response.token

    begin
      decoded = TokenDecoder.new(token, @oauth_client.id).decode
    rescue NotRegisteredError => error
      Rails.logger.warn("An unexpected exception occurred: #{error.inspect}")
      session[:user_jwt] = nil
      return
    end

    session[:user_jwt] = {value: decoded, httponly: true}
  end

  def get_holdings(instance_id:)
    []
  end

  private

  def client
    site = "#{ENV["KEYCLOAK_URL"]}/auth/realms/#{ENV["CATALOGUE_SERVICES_REALM"]}/.well-known/openid-configuration"
    OAuth2::Client.new(ENV["CATALOGUE_SERVICES_CLIENT"], ENV["CATALOGUE_SERVICES_SECRET"],
      site: site,
      authorize_url: "/protocol/openid-connect/auth",
      token_url: "/protocol/openid-connect/token")
  end
end
