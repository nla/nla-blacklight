require "simplecov"
require "simplecov-html"
require "simplecov_json_formatter"

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter
])

SimpleCov.start "rails" do
  # enable_coverage :branch

  add_filter do |source_file|
    source_file.lines.count < 10
  end

  # Filter out Blacklight files that are being overridden, but not modified (i.e. styling changes only)
  add_filter "app/components/blacklight/document_component.rb"
  add_filter "app/components/blacklight/metadata_field_layout_component.rb"
  add_filter "app/components/blacklight/response/pagination_component.rb"
  add_filter "app/components/blacklight/system/dropdown_component.rb"
  add_filter "app/components/blacklight/start_over_button_component.rb"
  add_filter "app/models/marc_indexer.rb"

  # Filter out hack around Turbo + Devise issue
  add_filter "app/controllers/turbo_devise_controller.rb"

  # Fixes error when user is not logged in
  add_filter "app/controllers/concerns/blacklight/bookmarks.rb"

  # Filter out override of Blacklight Advanced Search Plugin override
  add_filter "lib/blacklight_advanced_search/render_constraints_override.rb"

  # Filter out error handler
  add_filter "app/controllers/errors_controller.rb"

  # temporarily filter out bento search classes
  add_filter "app/item_decorators/bento_search/ebsco_eds_article_decorator.rb"
  # ignore since it's 90% copied from the bento_search eds_engine.rb
  add_filter "app/search_engines/bento_search/eds_publication_engine.rb"

  # ignore memory benchmark logging script
  add_filter "config/initializers/memlog.rb"

  add_group "Services", "app/services"
  add_group "Components", "app/components"
  add_group "Presenters", "app/presenters"
  add_group "Bento Search Engines", "app/search_engines"

  unless ENV["KC_PATRON_REALM"]
    add_filter "app/models/user_details.rb"
    add_filter "app/components/user_details_field_component.rb"
  end
end
