# start with the production config
load File.expand_path("production.rb", File.dirname(__FILE__ ))

# override configuration for staging

# allow requests to
config.hosts << "deshort.nla.gov.au"
config.hosts << "catalogue-test.nla.gov.au"
