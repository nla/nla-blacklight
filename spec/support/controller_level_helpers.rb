# frozen_string_literal: true

# This was borrowed from blacklight to allow setup of the search state and
# blacklight context for testing.
module ControllerLevelHelpers
  module ControllerViewHelpers
    def search_state
      @search_state ||= Blacklight::SearchState.new(params, blacklight_config, controller)
    end

    def search_session
      @current_search ||= {}
    end

    def current_search_session
      search_session
    end

    # This allows you to set the configuration
    # @example: view.blacklight_config = Blacklight::Configuration.new
    attr_writer :blacklight_config

    def blacklight_config
      @blacklight_config ||= Blacklight::Configuration.new(view_config: {title_field: "title_tsim"})
    end

    def blacklight_configuration_context
      @blacklight_configuration_context ||= Blacklight::Configuration::Context.new(controller)
    end
  end

  def initialize_controller_helpers(helper)
    helper.extend ControllerViewHelpers
  end

  # Monkeypatch to fix https://github.com/rspec/rspec-rails/pull/2521
  def _default_render_options
    val = super
    return val unless val[:handlers]

    val.merge(handlers: val.fetch(:handlers).map(&:to_sym))
  end
end
