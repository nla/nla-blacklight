# frozen_string_literal: true

module ThumbnailHelper
  NLA_OBJ_ID_FIELD = "nlaobjid_ss"

  def render_thumbnail(document, options = {})
    return if document.first("id").blank?

    service_options = {
      nlaObjId: document.first(NLA_OBJ_ID_FIELD).to_s,
      isbnList: document.valid_isbn&.join(",").to_s,
      lccnList: document.lccn&.join(",").to_s,
      width: thumbnail_image_width(document),
      id: document.first("id")
    }

    thumb_url = ThumbnailService.new.get_url(service_options)
    if thumb_url.present?
      image_tag thumb_url, options.merge({width: thumbnail_image_width(document)})
    end
  end

  def thumbnail_image_width(document)
    current_page?(solr_document_path(id: document.id)) ? 500 : 123
  end
end
