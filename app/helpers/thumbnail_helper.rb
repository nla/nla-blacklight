# frozen_string_literal: true

module ThumbnailHelper
  def render_thumbnail(document, options = {})
    return if document.first("id").blank?

    bib_id = document.first("id")
    isbn_list = document.isbn_list.join(",")
    lccn_list = document.lccn.join(",")

    width = current_page?(solr_document_path(id: bib_id)) ? 500 : 123
    thumb_url = cat_services_client.get_thumbnail(bib_id, isbn_list, lccn_list, width)
    if thumb_url.present?
      image_tag thumb_url, options
    end
  end
end
