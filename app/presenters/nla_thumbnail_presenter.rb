# frozen_string_literal: true

class NlaThumbnailPresenter < Blacklight::ThumbnailPresenter
  def initialize(document, view_context, view_config)
    @document = document
    @view_context = view_context
    @view_config = view_config
  end

  def link_value
    if document.online_access.present?
      document.online_access.first[:href]
    elsif document.copy_access.present?
      document.copy_access.first[:href]
    end
  end

  def is_catalogue_record_page?
    view_context.current_page?(view_context.solr_document_path(id: document.id))
  end

  private

  def thumbnail_value(image_options = nil)
    image_options = image_options&.merge({alt: alt_title_from_document, onerror: "this.style.display='none'", class: thumbnail_classes, data: {"scroll-reveal-target": "item", delay: "150ms"}})
    if image_options.nil?
      default_thumbnail_value(image_options)
    elsif thumbnail_method
      view_context.send(thumbnail_method, document, image_options)
    elsif thumbnail_field
      image_url = thumbnail_value_from_document
      view_context.image_tag image_url, image_options if image_url.present?
    end
  end

  def thumbnail_classes
    is_catalogue_record_page? ? "thumbnail" : "w-100 thumbnail"
  end

  def alt_title_from_document
    retrieve_values(field_config(@view_config[:title_field])).compact_blank.first
  end
end
