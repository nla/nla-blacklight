# frozen_string_literal: true

class StaffOnlyComponent < Blacklight::MetadataFieldComponent
  def initialize(field:, layout: nil, show: false)
    super
  end

  def before_render
    @in_staff_subnet = helpers.client_in_subnets(helpers.staff_subnets)
  end

  def render?
    @in_staff_subnet || false
  end
end
