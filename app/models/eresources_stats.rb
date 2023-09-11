# frozen_string_literal

class EresourcesStats
  attr_reader :payload

  def initialize(resource, user_type)
    @payload = JSON.generate(
      resource: {entry: {remoteaccess: resource[:entry]["remoteaccess"], title: resource[:entry]["title"].strip}},
      timestamp: Time.now.to_i,
      user_type: user_type.to_s
    )
  end
end
