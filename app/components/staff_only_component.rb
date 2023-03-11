# frozen_string_literal: true

class StaffOnlyComponent < Blacklight::MetadataFieldComponent
  def initialize(field:, layout: nil, show: false)
    super
  end

  def before_render
    @in_staff_subnet = helpers.user_location == :staff
  end

  def render?
    @in_staff_subnet || false
  end
end
