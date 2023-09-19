# frozen_string_literal: true

module FieldHelper
  def paragraphs(document:, field:, config:, value:, context:)
    if value.present?
      elements = []

      elements << safe_join(value.map do |para|
        content_tag(:p, class: "mb-0") do
          link_urls para
        end
      end, "")

      safe_join(elements, "")
    end
  end

  # Display linked items. If there is more than one item in the list
  # show the values in an unordered list.
  def url_list(document:, field:, config:, value:, context: "show")
    elements = []

    if value.size > 1
      elements << content_tag(:ul) do
        safe_join(value.map do |link|
          content_tag(:li) do
            list_content = []
            list_content += makelink(document: document, href: link[:href], text: link[:text], extended_info: true)
            if document.has_broken_links? && document.broken_links[link[:href]]
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
      elements += makelink(document: document, href: link[:href], text: link[:text], extended_info: true)

      if document.has_broken_links? && document.broken_links[link[:href]]
        elements << content_tag(:p, class: "small") do
          build_broken_link(document.broken_links[link[:href]])
        end
      end
    end

    safe_join(elements, "\n")
  end

  # Displays values in an unordered list if there is more than one
  def list(document:, field:, config:, value:, context:)
    elements = []

    elements << if value.size > 1
      content_tag(:ul) do
        safe_join(value.map do |val|
          content_tag(:li) do
            link_urls val
          end
        end, "\n")
      end
    else
      link_urls value.first
    end

    safe_join(elements, "\n")
  end

  # display lists without bullets
  def unstyled_list(document:, field:, config:, value:, context:)
    elements = []

    elements << if value.size > 1
      content_tag(:ul, class: "list-unstyled") do
        safe_join(value.map do |val|
          content_tag(:li) do
            link_urls val
          end
        end, "\n")
      end
    else
      link_urls value.first
    end

    safe_join(elements, "\n")
  end

  def emphasized_list(document:, field:, config:, value:, context:)
    elements = []

    elements << if value.size > 1
      content_tag(:ul) do
        safe_join(value.map do |val|
          content_tag(:li) do
            content_tag(:strong) do
              link_urls val
            end
          end
        end, "\n")
      end
    else
      content_tag(:strong) do
        link_urls value.first
      end
    end

    safe_join(elements, "\n")
  end

  # Display combined notes (i.e. notes and linked 880 notes). Shown as
  # an unordered list if there are multiple notes. URLs in notes will
  # be turned into links.
  def notes(document:, field:, config:, value:, context:)
    if value.present?
      elements = [*build_notes_list(value)]
      safe_join(elements.compact_blank, "\n")
    end
  end

  # Create a link to Map Search
  def map_search(document:, field:, config:, value:, context:)
    if value.present?
      # rubocop:disable Rails/OutputSafety
      link_to("View this map in Map Search", value.first.html_safe, class: "text-break")
      # rubocop:enable Rails/OutputSafety
    end
  end

  def render_copyright_component(document:, field:, config:, value:, context:)
    if value.present? && value.first.present? && value.first["contextMsg"].present?
      render CopyrightStatusComponent.new(value.first)
    end
  end

  def subject_search_list(document:, field:, config:, value:, context:)
    if value.present?
      catalogue_search_list(value, "subject", bulleted: false, search_values: document.fetch("subject_ssim"))
    end
  rescue KeyError
    Rails.logger.info "Record #{document.id} has no '#{field}'"
  end

  def render_related_records_component(document:, field:, config:, value:, context:)
    if value.present?
      render RelatedRecordsComponent.with_collection(value)
    end
  end

  def occupation_search_list(document:, field:, config:, value:, context:)
    catalogue_search_list(value, "occupation")
  end

  def genre_search_list(document:, field:, config:, value:, context:)
    catalogue_search_list(value, "genre")
  end

  def title_search_list(document:, field:, config:, value:, context:)
    catalogue_search_list(value, "title", bulleted: true)
  end

  def author_search_list(document:, field:, config:, value:, context:)
    catalogue_search_list(value, "author", bulleted: false, search_values: document.fetch("author_ssim"))
  end

  def other_author_search_list(document:, field:, config:, value:, context:)
    catalogue_search_list(value, "author", bulleted: false, search_values: document.fetch("author_addl_ssim"))
  end

  private

  # Original RegEx used by VuFind
  URL_REGEX = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=+$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=+$,\w]+@)[A-Za-z0-9.-]+)((?:\/[+~%\/.[A-Za-z0-9_]-_]*)?\??(?:[-+=&;%@.\w_]*)#?(?:[\w\/.]*))?)/

  def build_broken_link(broken_link)
    broken_el = []
    broken_el << "Broken link? let us search "
    broken_el << link_to("Trove", broken_link[:trove], class: "text-break")
    broken_el << ", the "
    broken_el << link_to("Wayback Machine", broken_link[:wayback], class: "text-break")
    broken_el << ", or "
    broken_el << link_to("Google", broken_link[:google], class: "text-break")
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
        end, "")
      end
    else
      link_urls(values.first)
    end

    safe_join(elements, "\n")
  end

  def link_urls(value)
    if value.present?
      # rubocop:disable Rails/OutputSafety
      value.gsub(URI::DEFAULT_PARSER.make_regexp(%w[http https]), '<a href="\0" class="text-break">\0</a>').html_safe
      # rubocop:enable Rails/OutputSafety
    end
  end

  def catalogue_search_list(values, search_field, bulleted: false, search_values: nil)
    if values.empty?
      return nil
    end

    elements = []
    elements << if search_values.nil?
      build_catalogue_search_link(values, search_field, bulleted)
    else
      build_catalogue_search_link_with_search_value(values, search_values, search_field, bulleted)
    end
    safe_join(elements, "\n")
  end

  def build_catalogue_search_link(values, search_field, bulleted)
    elements = []

    elements << if values.size > 1
      content_tag(:ul, class: (bulleted ? "" : "list-unstyled").to_s) do
        safe_join(values.map do |val|
          content_tag(:li) do
            link_to val, search_catalog_path({search_field: search_field, q: "\"#{val}\""}), class: "text-break"
          end
        end, "\n")
      end
    else
      link_to values.first, search_catalog_path({search_field: search_field, q: "\"#{values.first}\""}), class: "text-break"
    end
  end

  def build_catalogue_search_link_with_search_value(values, search_values, search_field, bulleted)
    elements = []

    elements << if values.size > 1
      zipped_values = values.zip search_values
      content_tag(:ul, class: (bulleted ? "" : "list-unstyled").to_s) do
        safe_join(zipped_values.map do |val, search_val|
          content_tag(:li) do
            link_to val, search_catalog_path({search_field: search_field, q: "\"#{search_val}\""}), class: "text-break"
          end
        end, "\n")
      end
    else
      link_to values.first, search_catalog_path({search_field: search_field, q: "\"#{search_values.first}\""}), class: "text-break"
    end
  end
end
