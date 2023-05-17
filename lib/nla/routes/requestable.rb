# frozen_string_literal: true

module Nla
  module Routes
    class Requestable
      def initialize(defaults = {})
        @defaults = defaults
      end

      def call(mapper, _options = {})
        mapper.member do
          mapper.get "request/new", action: "new_request", as: "new_request"
          mapper.post "request", action: "create_request"
        end
      end
    end
  end
end
