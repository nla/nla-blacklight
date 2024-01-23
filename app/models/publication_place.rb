# frozen_string_literal: true

class PublicationPlace
  def initialize(document)
    @document = document
  end

  def value
    data = @document.fetch("display_publication_place_ssim", nil)
    if data.present?
      publication_place = data.join(" ")
      if publication_place.end_with?(":")
        publication_place.chop!
      end
      publication_place.strip
    end
  end
end
