# frozen_string_literal: true

class LinkedValuePresenter < Blacklight::FieldPresenter
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::TagHelper

  attr_reader :view_context, :document, :field_config, :except_operations, :options
  delegate :key, :component, to: :field_config

  def render
    elements = []

    if values.size > 1
      elements << view_context.content_tag(:ul) do
        safe_join(values.map do |value|
          view_context.content_tag(:li) do
            view_context.link_to value[:text], value[:href]
          end
        end, "\n")
      end
    else
      link_data = values.first
      elements << @view_context.link_to(link_data[:text], link_data[:href])
    end

    safe_join(elements, "\n")
  end

  def values
    @values ||= retrieve_values
  end

  private

  def retrieve_values
    key = @field_config[:key]
    if key == "online_access"
      document.online_access
    elsif key == "copy_access"
      document.copy_access
    elsif key == "related_access"
      document.related_access
    end
  end
end
