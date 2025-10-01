require 'pyroscope'

app_name   = ENV.fetch('PYROSCOPE_APP_NAME', 'catalogue')
server_addr = ENV.fetch('PYROSCOPE_SERVER_ADDRESS', 'https://pyroscope.apps.dev-containers.nla.gov.au')

Pyroscope.configure do |config|
  config.application_name = app_name
  config.server_address   = server_addr
end
