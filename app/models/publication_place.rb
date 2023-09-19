# frozen_string_literal: true

class PublicationPlace

  def initialize(document)
    @document = document
  end

  def value
    data = @document.publication_place
    if data.present?
      publication_place = data.join(" ")
      if publication_place.end_with?(":")
        publication_place.chop!
      end
      publication_place.strip
    end
  end
end
