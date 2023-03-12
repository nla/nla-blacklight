# frozen_string_literal: true

require "nla/blacklight/user_location"

class StaffOnlyConstraint
  def matches?(request)
    location = Nla::Blacklight::UserLocation.instance.location request
    location == :staff || Rails.env.development?
  end
end
