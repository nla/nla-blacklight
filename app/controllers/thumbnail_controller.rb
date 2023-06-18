# frozen_string_literal: true

class ThumbnailController < CatalogController
  def thumbnail
    _, @document = search_service.fetch(params[:id])
    render layout: false, locals: {document: @document}
  end
end
