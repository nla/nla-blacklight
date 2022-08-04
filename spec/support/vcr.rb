require "vcr"

VCR.configure do |c|
  vcr_mode = /rec/i.match?(ENV["VCR_MODE"]) ? :all : :once

  c.default_cassette_options = {
    record: vcr_mode,
    match_requests_on: %i[method uri body]
  }

  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.ignore_localhost = true
  c.configure_rspec_metadata!

  %w[
    DATABASE_URL
    SOLR_URL
    GETALIBRARYCARD_BASE_URL
    ZK_HOST
    SOLR_COLLECTION
  ].each do |key|
    c.filter_sensitive_data("<#{key}>") { ENV[key] }
  end
end
