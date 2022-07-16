require Rails.root.join("lib/devise/strategies/getalibrarycard_authenticatable.rb")
require "faraday"
require "faraday/middleware"
require "faraday/adapter/net_http"

module Devise
  module Models
    module GetalibrarycardAuthenticatable
      extend ActiveSupport::Concern

      def self.required_fields(klass)
        [:barcode, :family_name]
      end

      # Verifies whether a password (ie from sign in) is the user password.
      def valid_password?(password)
        family_name == password
      end

      protected

      module ClassMethods
        # We assume this method already gets the sanitized values from the
        # GetalibrarycardAuthenticatable strategy. If you are using this method on
        # your own, be sure to sanitize the conditions hash to only include
        # the proper fields.
        def find_for_getalibrarycard_authentication(conditions)
          conn = Faraday.new(ENV["GETALIBRARYCARD_BASE_URL"]) do |f|
            f.response :xml, content_type: /\bxml$/
            f.adapter :net_http
          end
          response = conn.post("#{ENV["GETALIBRARYCARD_AUTH_PATH"]}/#{conditions[:barcode]}/#{conditions[:family_name]}")

          if response.present? && response.status == 200
            patron_id = response.body["response"]["itemList"]["item"][0]["id"]
            voyager_id = response.body["response"]["itemList"]["item"][0]["voyid"]

            user = find_for_authentication({patron_id: patron_id})
            user.presence || User.create!({patron_id: patron_id.to_i, voyager_id: voyager_id.to_i})
          end
        end
      end
    end
  end
end
