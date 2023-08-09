# frozen_string_literal: true

module ThumbnailHelper
  NLA_OBJ_ID_FIELD = "nlaobjid_ss"

  def render_thumbnail(document, options = {})
    return if document.first("id").blank?

    service_options = {
      nlaObjId: document.first(NLA_OBJ_ID_FIELD),
      isbnList: document.isbn_list.join(","),
      lccnList: document.lccn.join(","),
      width: thumbnail_image_width(document)
    }

    thumb_url = ThumbnailService.new.get_url(service_options)
    if thumb_url.present?
      image_tag thumb_url, options
    else
      Rails.logger.warn "Failed to retrieve thumbnail for #{document.first("id")}"
      nil
    end
  end

  def thumbnail_image_width(document)
    current_page?(solr_document_path(id: document.id)) ? 500 : 123
  end
end
