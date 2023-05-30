source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# All runtime config comes from the UNIX environment
# but we use dotenv to store that in files for development and testing
gem "dotenv-rails", groups: [:development, :test]

# Brakeman analyzes our code for security vulnerabilities
gem "brakeman"

# bundler-audit checks our dependencies for vulnerabilities
gem "bundler-audit"

# lograge changes Rails' logging to a more
# traditional one-line-per-event format
gem "lograge"

# stores user session in the database rather than the browser cookie
gem "activerecord-session_store", "~> 2.0"

# in Rails scheduler
gem "rufus-scheduler", "~> 3.8"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use hiredis adapter for better performance than the "redis" gem
gem "hiredis", "~> 0.6.3"
gem "hiredis-client", "~> 0.14.0"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Blacklight dependencies
gem "blacklight", "~> 7.32"
gem "blacklight_advanced_search", "~> 7.0"
gem "blacklight-marc", ">= 7.0.0.rc1", "< 9"
gem "bootstrap", "~> 4.0"
gem "jquery-rails"
gem "rsolr", ">= 1.0", "< 3"
gem "twitter-typeahead-rails", "0.11.1"
gem "blacklight_range_limit"

gem "nokogiri", ">= 1.13.9"
gem "addressable", "~> 2.8"
gem "repost", "~> 0.4.1"
gem "strong_migrations", "~> 1.4"
gem "view_component", "~> 2.82"
gem "zk", "~> 1.10"
gem "down", "~> 5.0"
gem "json-jwt", "~> 1.15"
gem "oauth2", "~> 2.0"

gem "ebsco-eds"
gem "httpclient"
gem "htmlentities"
gem "openurl"

# feature flags
gem "flipper", "~> 0.28.0"
gem "flipper-active_record", "~> 0.28.0"
gem "flipper-ui", "~> 0.28.0"

# Fixes CVE-2023-28755
gem "uri", "~> 0.12.1"

# Before a release, point these gem at a tag, instead of the `main` branch.
gem "blacklight-solrcloud-repository", git: "https://github.com/nla/blacklight-solrcloud-repository", tag: "0.2.3"
gem "catalogue-patrons", git: "https://github.com/nla/catalogue-patrons", tag: "3.2.0"
gem "bento_search", git: "https://github.com/nla/bento_search.git", tag: "0.0.1"

# For local development, comment out above ⤴️ and uncomment below ⤵️. Assumes this directory and
# the gems below are in the same directory. Adjust if needed to match your local dev environment.
# gem "blacklight-solrcloud-repository", path: "../blacklight-solrcloud-repository"
# gem "catalogue-patrons", path: "../catalogue-patrons"
# gem "bento_search", path: "../bento_search"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "standard", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "solr_wrapper", ">= 0.3"

  gem "rspec-rails", "~> 6.0"
  gem "shoulda-matchers"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "awesome_print"

  # improve the Rails error console in development
  gem "better_errors"
  gem "binding_of_caller"

  gem "annotate"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "database_cleaner-active_record"
  gem "rails-controller-testing", "~> 1.0", ">= 1.0.5"
  gem "webmock"

  gem "simplecov", "~> 0.22.0"
  gem "simplecov-json", "~> 0.2.3"

  gem "mock_redis", "~> 0.36.0"
end
