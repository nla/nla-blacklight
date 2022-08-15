module FieldHelper

  ##
  # Display linked field data. If there is more than one item in the list
  # show the values in an unordered list.
  def url_list(document:, field:, config:, value:, context:)
    elements = []

    if value.size > 1
      elements << content_tag(:ul) do
        safe_join(value.map do |link|
          content_tag(:li) do
            list_content = []
            list_content << link_to(link[:text], link[:href])
            if document.has_broken_links?
              list_content << content_tag(:p, class: "small") do
                build_broken_link(document.broken_links[link[:href]])
              end
            end
            safe_join(list_content, "\n")
          end
        end, "\n")
      end
    else
      link = value.first
      elements << link_to(link[:text], link[:href])

      if document.has_broken_links?
        elements << content_tag(:p, class: "small") do
          build_broken_link(document.broken_links[link[:href]])
        end
      end
    end

    safe_join(elements, "\n")
  end

  def list(document:, field:, config:, value:, context:)
    elements = []

    elements << if value.size > 1
      content_tag(:ul) do
        safe_join(value.map do |val|
          content_tag(:li) do
            val
          end
        end, "\n")
      end
    else
      value.first
    end

    safe_join(elements, "\n")
  end

  def notes(document:, field:, config:, value:, context:)
    elements = []

    notes_hash = value.first
    elements << build_notes_list(notes_hash[:notes]) if notes_hash[:notes].present?
    elements << build_notes_list(notes_hash[:more_notes]) if notes_hash[:more_notes].present?

    safe_join(elements.compact_blank, "\n")
  end

  def map_search(document:, field:, config:, value:, context:)
    elements = []

    elements << link_to("View this map in Map Search", value.first)

    safe_join(elements, "\n")
  end

  private

  # Original RegEx used by VuFind
  URL_REGEX = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=+$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=+$,\w]+@)[A-Za-z0-9.-]+)((?:\/[+~%\/.[A-Za-z0-9_]-_]*)?\??(?:[-+=&;%@.\w_]*)#?(?:[\w\/.]*))?)/

  def build_broken_link(broken_link)
    broken_el = []
    broken_el << "Broken link? let us search "
    broken_el << link_to("Trove", broken_link[:trove])
    broken_el << ", the "
    broken_el << link_to("Wayback Machine", broken_link[:wayback])
    broken_el << ", or "
    broken_el << link_to("Google", broken_link[:google])
    broken_el << " for you."
    safe_join(broken_el, "\n")
  end

  def build_notes_list(values)
    elements = []

    elements << if values.size > 1
      content_tag(:ul) do
        safe_join(values.map do |value|
          content_tag(:li) do
            link_urls(value)
          end
        end, "\n")
      end
    else
      values.first
    end

    safe_join(elements, "\n")
  end

  def link_urls(value)
    result = value

    unless value.empty?
      # rubocop:disable Rails/OutputSafety
      result = value.gsub(URI::DEFAULT_PARSER.make_regexp(%w[http https]), '<a href="\0">\0</a>').html_safe
      # rubocop:enable Rails/OutputSafety
    end

    result
  end
end
