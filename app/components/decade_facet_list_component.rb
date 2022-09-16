# frozen_string_literal: true

class DecadeFacetListComponent < Blacklight::FacetFieldListComponent
  def render_facet_limit_list(paginator, facet_field, wrapping_element = :li)
    reverse_items = paginator.items.sort_by { |i| -i[:value] }.reverse
    paginator.instance_variable_set(:@all, reverse_items)

    super
  end
end
