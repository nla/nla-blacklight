# frozen_string_literal: true

module ThumbnailHelper
  def render_thumbnail(document, options = {})
    return if document.first("id").blank?

    service_options = {
      nlaObjId: document.first("nlaobjid_ss"),
      isbnList: document.isbn_list.join(","),
      lccnList: document.lccn.join(","),
      width: thumbnail_image_width(document)
    }

    thumb_url = thumbnail_service.get_url(service_options)
    if thumb_url.present?
      image_tag thumb_url, options
    end
  end

  def thumbnail_image_width(document)
    current_page?(solr_document_path(id: document.id)) ? 500 : 123
  end
end
