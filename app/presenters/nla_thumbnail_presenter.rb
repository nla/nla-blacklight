# frozen_string_literal: true

class NlaThumbnailPresenter < Blacklight::ThumbnailPresenter
  def link_value
    thumbnail_value_from_document
  end

  def alt_title_from_document
    retrieve_values(field_config(@view_config[:title_field])).compact_blank.first
  end

  # :nocov:
  def thumbnail_tag(image_options = {}, url_options = {})
    value = thumbnail_value(image_options)
    return value if value.nil? || url_options[:suppress_link]

    if is_catalogue_record_page?
      view_context.link_to value, link_value, url_options
    else
      view_context.link_to value, view_context.solr_document_path(document), url_options
    end
  end
  # :nocov:

  def is_catalogue_record_page?
    view_config[:key] == :show
  end

  private

  # @param [Hash] image_options to pass to the image tag
  # :nocov:
  def thumbnail_value(image_options)
    image_options = image_options.merge({alt: alt_title_from_document, onerror: "this.style.display='none'", class: "w-100"})
    value = if thumbnail_method
      view_context.send(thumbnail_method, document, image_options)
    elsif thumbnail_field
      image_url = thumbnail_value_from_document
      unless image_url.blank? || image_url.include?("nla.arc")
        image_url += if @view_config[:top_level_config] == :show
          "/image?wid=500"
        else
          "/image?wid=123"
        end
        view_context.image_tag image_url, image_options if image_url.present?
      end
    end

    value || default_thumbnail_value(image_options)
  end
  # :nocov:
end
