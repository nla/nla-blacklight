require "vcr"

VCR.configure do |c|
  vcr_mode = /rec/i.match?(ENV["VCR_MODE"]) ? :all : :once

  c.default_cassette_options = {
    record: vcr_mode,
    match_requests_on: %i[method uri body]
  }

  c.cassette_library_dir = "features/cassettes"
  c.hook_into :webmock
  c.ignore_localhost = true
  %w[
    DATABASE_URL
    SOLR_URL
    GETALIBRARYCARD_BASE_URL
    ZK_HOST
    SOLR_COLLECTION
    KEYCLOAK_CLIENT
    KEYCLOAK_SECRET
    KEYCLOAK_URL
    KEYCLOAK_REALM
  ].each do |key|
    c.filter_sensitive_data("<#{key}>") { ENV[key] }
  end
end

VCR.cucumber_tags do |t|
  t.tag "@vcr", use_scenario_name: true
end
