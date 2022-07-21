require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.ignore_localhost = true
  c.configure_rspec_metadata!

  c.filter_sensitive_data("<SOLR_URL>") do
    ENV["SOLR_URL"]
  end
  c.filter_sensitive_data("<DATABASE_URL>") do
    ENV["DATABASE_URL"]
  end
  c.filter_sensitive_data("<GALC_AUTH_PATH>") do
    ENV["GETALIBRARYCARD_AUTH_PATH"]
  end
  c.filter_sensitive_data("<GALC_PATRON_PATH>") do
    ENV["GETALIBRARYCARD_PATRON_DETAILS_PATH"]
  end
end
