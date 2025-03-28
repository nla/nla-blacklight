# frozen_string_literal: true

module Blacklight
  class TopNavbarComponent < Blacklight::Component
    def initialize(blacklight_config:)
      @blacklight_config = blacklight_config
    end

    attr_reader :blacklight_config

    delegate :application_name, :container_classes, to: :helpers

    def logo_link(title: application_name)
      link_to blacklight_config.logo_text, blacklight_config.logo_link, class: "py-0 my-2 navbar-brand navbar-logo"
    end
  end
end
