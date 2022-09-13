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

  # Filter out Cucumber Rake task since it's generated at install
  add_filter "lib/tasks/cucumber.rake"

  # Filter out Blacklight files that are being overridden, but not modified
  add_filter "app/components/blacklight/response/pagination_component.rb"
  add_filter "app/models/marc_indexer.rb"

  # Filter out hack around Turbo + Devise issue
  add_filter "app/controllers/turbo_devise_controller.rb"

  add_group "Components", "app/components"
  add_group "Presenters", "app/presenters"
end
