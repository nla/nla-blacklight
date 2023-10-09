# frozen_string_literal: true

class StaffOnlyComponent < Blacklight::MetadataFieldComponent
  def before_render
    @in_staff_subnet = helpers.user_location == :staff
  end

  def render?
    @in_staff_subnet || false
  end
end
