# frozen_string_literal: true

module ThumbnailHelper
  def render_thumbnail(document, options = {})
    return if document.first("id").blank?

    service_options = {
      nlaObjId: document.first("nlaobjid_ss"),
      isbnList: document.isbn_list.join(","),
      lccnList: document.lccn.join(","),
      width: thumbnail_image_width
    }

    thumb_url = thumbnail_service.get_url(service_options)
    if thumb_url.present?
      image_tag thumb_url, options
    end
  end

  def thumbnail_image_width
    path = Rails.application.routes.recognize_path request.referer
    (path[:controller] == "catalog" && path[:action] == "show") ? 500 : 123
  end
end
