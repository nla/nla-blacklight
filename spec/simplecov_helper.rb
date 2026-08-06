require "simplecov"
require "simplecov-html"
require "simplecov_json_formatter"

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter
])

SimpleCov.start "rails" do
  # enable_coverage :branch

  skip do |source_file|
    source_file.lines.count < 10
  end

  # Filter out Blacklight files that are being overridden, but not modified (i.e. styling changes only)
  skip "app/components/blacklight/document_component.rb"
  skip "app/components/blacklight/metadata_field_layout_component.rb"
  skip "app/components/blacklight/response/pagination_component.rb"
  skip "app/components/blacklight/system/dropdown_component.rb"
  skip "app/components/blacklight/start_over_button_component.rb"
  skip "app/models/marc_indexer.rb"

  # Filter out hack around Turbo + Devise issue
  skip "app/controllers/turbo_devise_controller.rb"

  # Fixes error when user is not logged in
  skip "app/controllers/concerns/blacklight/bookmarks.rb"

  # Filter out override of Blacklight Advanced Search Plugin override
  skip "lib/blacklight_advanced_search/render_constraints_override.rb"

  # Filter out error handler
  skip "app/controllers/errors_controller.rb"

  # temporarily filter out bento search classes
  skip "app/item_decorators/bento_search/ebsco_eds_article_decorator.rb"
  # ignore since it's 90% copied from the bento_search eds_engine.rb
  skip "app/search_engines/bento_search/eds_publication_engine.rb"

  # ignore memory benchmark logging script
  skip "config/initializers/memlog.rb"

  group "Services", "app/services"
  group "Components", "app/components"
  group "Presenters", "app/presenters"
  group "Bento Search Engines", "app/search_engines"
end
