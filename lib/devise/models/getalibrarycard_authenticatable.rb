require Rails.root.join("lib", "devise", "strategies", "getalibrarycard_authenticatable.rb")
require "faraday"
require "faraday/middleware"
require "faraday/adapter/net_http"
require "nokogiri"

module Devise
  module Models
    module GetalibrarycardAuthenticatable
      extend ActiveSupport::Concern

      def required_fields(*)
        [:username, :password]
      end

      # Verifies whether a password (ie from sign in) is the user password.
      def valid_password?(password)
        family_name == password
      end

      def after_getalibrarycard_authentication
        conn = Faraday.new(ENV["GETALIBRARYCARD_BASE_URL"]) do |f|
          f.adapter :net_http
        end
        response = conn.get(ENV["GETALIBRARYCARD_PATRON_DETAILS_PATH"] % [patron_id])

        if response.present? && response.status == 200
          doc = Nokogiri::XML(response.body)
          self.name_given = doc.xpath("//item[@name='nameGiven']").text
          self.name_family = doc.xpath("//item[@name='nameFamily']").text
          self.email = doc.xpath("//item[@name='email']").text
          self.encrypted_password = Devise::Encryptor.digest(self.class, Devise.friendly_token(20))
          save!
        end
      end

      protected

      module ClassMethods
        Devise::Models.config(self, :pepper, :stretches)

        # We assume this method already gets the sanitized values from the
        # GetalibrarycardAuthenticatable strategy. If you are using this method on
        # your own, be sure to sanitize the conditions hash to only include
        # the proper fields.
        def find_for_getalibrarycard_authentication(conditions)
          conn = Faraday.new(ENV["GETALIBRARYCARD_BASE_URL"]) do |f|
            f.adapter :net_http
          end
          response = conn.post(ENV["GETALIBRARYCARD_AUTH_PATH"] % [conditions[:username], conditions[:password]])

          if response.present? && response.status == 200
            doc = Nokogiri::XML(response.body)
            identity = doc.xpath("//item[@name='LOON-USER-AUTHENTICATED']")
            patron_id = identity.xpath("@id").text
            voyager_id = identity.xpath("@voyid").text

            user = find_for_authentication({patron_id: patron_id})
            user.presence || User.create!({patron_id: patron_id, voyager_id: voyager_id})
          end
        end
      end
    end
  end
end
