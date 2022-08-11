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
            list_content = []
            list_content << view_context.link_to(value[:text], value[:href])
            if document.has_broken_links?
              list_content << view_context.content_tag(:p, class: "small") do
                build_broken_link(value[:href])
              end
            end
            safe_join(list_content, "\n")
          end
        end, "\n")
      end
    else
      link_data = values.first
      elements << @view_context.link_to(link_data[:text], link_data[:href])

      # broken links
      if document.has_broken_links?
        elements << view_context.content_tag(:p, class: "small") do
          build_broken_link(link_data[:href])
        end
      end
    end

    safe_join(elements, "\n")
  end

  private

  def build_broken_link(url)
    broken_link = document.broken_links[url]
    broken_el = []
    broken_el << "Broken link? let us search "
    broken_el << view_context.link_to("Trove", broken_link[:trove])
    broken_el << ", the "
    broken_el << view_context.link_to("Wayback Machine", broken_link[:wayback])
    broken_el << ", or "
    broken_el << view_context.link_to("Google", broken_link[:google])
    broken_el << " for you."
    safe_join(broken_el, "\n")
  end
end
