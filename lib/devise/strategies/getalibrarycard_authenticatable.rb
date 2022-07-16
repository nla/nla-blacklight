require "devise/strategies/authenticatable"

require "faraday"
require "faraday/adapter/net_http"

module Devise
  module Strategies
    class GetalibrarycardAuthenticatable < Authenticatable
      def authenticate!
        resource = authentication_hash[:barcode].present? && mapping.to.find_for_getalibrarycard_authentication(authentication_hash)

        if resource.present?
          success!(resource)
        else
          fail!(I18n.t("devise.failure.invalid"))
        end
      end
    end
  end
end

Warden::Strategies.add(:getalibrarycard_authenticatable, Devise::Strategies::GetalibrarycardAuthenticatable)
