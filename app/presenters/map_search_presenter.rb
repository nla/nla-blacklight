# frozen_string_literal: true

class MapSearchPresenter < Blacklight::FieldPresenter
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::TagHelper

  attr_reader :view_context, :document, :field_config, :except_operations, :options
  delegate :key, :component, to: :field_config

  def render
    elements = []

    elements << view_context.link_to("View this map in Map Search", values.first)

    safe_join(elements, "\n")
  end

  def render_field?
    values.first.present? unless values.empty?
  end
end
