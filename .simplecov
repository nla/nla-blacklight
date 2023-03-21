require "simplecov-html"
require "simplecov_json_formatter"

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter
])

SimpleCov.start "rails" do
  enable_coverage :branch

  add_filter do |source_file|
    source_file.lines.count < 10
  end

  # Filter out Blacklight files that are being overridden, but not modified (i.e. styling changes only)
  add_filter "app/components/blacklight/document_component.rb"
  add_filter "app/components/blacklight/metadata_field_layout_component.rb"
  add_filter "app/components/blacklight/response/pagination_component.rb"
  add_filter "app/components/blacklight/system/dropdown_component.rb"
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
  add_filter "app/controllers/search_controller.rb"
  add_filter "app/item_decorators/bento_search/ebsco_eds_article_decorator.rb"
  add_filter "app/search_engines/bento_search/ebsco_eds_engine.rb"
  add_filter "app/search_engines/bento_search/solr_engine.rb"
  add_filter "app/search_engines/bento_search/solr_engine_single.rb"
  add_filter "app/search_engines/bento_search/finding_aids_engine.rb"
  add_filter "app/helpers/single_search_helper.rb"
  add_filter "app/helpers/application_helper.rb"

  add_group "Components", "app/components"
  add_group "Presenters", "app/presenters"
end
