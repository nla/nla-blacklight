require Rails.root.join("lib/devise/strategies/getalibrarycard_authenticatable.rb")
require "faraday"
require "faraday/middleware"
require "faraday/adapter/net_http"

module Devise
  module Models
    module GetalibrarycardAuthenticatable
      extend ActiveSupport::Concern

      included do
        attr_reader :patron_id, :voyager_id
        attr_accessor :patron_id, :voyager_id
      end

      def initialize(*args, &block)
        super
      end

      def self.required_fields(klass)
        [:barcode, :family_name]
      end

      # Verifies whether a password (ie from sign in) is the user password.
      def valid_password?(password)
        family_name == password
      end

      protected

      module ClassMethods
        Devise::Models.config(self, :stretches,)

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

            user = User.where(patron_id: patron_id).first
            if user.blank?
              user = new
              user[:barcode] = conditions[:barcode]
              user[:patron_id] = patron_id
              user[:voyager_id] = voyager_id
            else
              user[:barcode] = conditions[:barcode]
            end

            user.save!
            User.where(patron_id: patron_id).first
          end
        end

        ####################################
        # Overriden methods from Devise::Models::Authenticatable
        ####################################

        # This method takes as many arguments as there are elements in `serialize_into_session`
        #
        # It recreates a resource from session data
        #
        def serialize_from_session(id, patron_id, voyager_id)
          find(id)
        end

        # Serialize any data you want into the Session.  The Resources Primary Key or other Unique Identifier
        # is recommended.
        #
        # The items placed into this array must be Serializable, e.g. numbers, strings, symbols, and Hashes.
        # Do not place entire Ruby Objects or Arrays of Objects into the Session.
        #
        def serialize_into_session(resource)
          [resource.id, resource.patron_id, resource.voyager_id]
        end
      end
    end
  end
end
