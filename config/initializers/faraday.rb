# frozen_string_literal: true

# Make sure Faraday requests include a non-default User-Agent, since it will break the specs
# every time Faraday is upgraded.
Faraday.default_connection_options = {headers: {user_agent: "nla-blacklight/#{Rails.configuration.version}"}}
