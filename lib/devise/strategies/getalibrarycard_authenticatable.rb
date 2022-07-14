require "devise/strategies/authenticatable"

require "faraday"
require "faraday/adapter/net_http"

module Devise
  module Strategies
    class GetalibrarycardAuthenticatable < Authenticatable
      def authenticate!
        resource = mapping.to.find_for_getalibrarycard_authentication(authentication_hash)

        if resource.present?
          success!(resource)
        else
          fail!("Invalid User ID or Family Name")
        end
      end
    end
  end
end

Warden::Strategies.add(:getalibrarycard_authenticatable, Devise::Strategies::GetalibrarycardAuthenticatable)
