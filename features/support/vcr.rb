require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.ignore_localhost = true
end

VCR.cucumber_tags do |t|
  t.tag "@vcr", use_scenario_name: true
end
