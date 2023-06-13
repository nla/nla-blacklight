# frozen_string_literal: true

class MlaCitationService
  def initialize(document)
    @document = document
  end

  def cite
    format = @document.first("format").downcase

    result = []

    result << cite_authors
    result << "<em>#{@document.first("title_tsim")}</em>"
    if format == "book"
      result << cite_publisher
    end
    result << @document.first("date_lower_isi").to_s if @document.first("date_lower_isi").present?
    result << cite_url

    result.join(" ")
  end

  def cite_authors
    cited_authors = []
    author = @document.first("author_with_relator_ssim")
    if author.present?
      cited_authors << author.to_s
    end

    @document.other_authors.each do |other_author|
      cited_authors << other_author.to_s
    end

    if cited_authors.present?
      "#{cited_authors.join(" and ")}."
    end
  end

  def cite_publisher
    cited_publisher = ""

    publisher = @document.publisher
    if publisher.present?
      publication_place = @document.publication_place
      cited_publisher += if publication_place.present?
        "#{publisher} #{publication_place}"
      else
        publisher
      end
    end

    cited_publisher
  end

  def cite_url
    url = ""

    copy_access = @document.copy_access.first
    related_access = @document.related_access.first
    if copy_access.present? && copy_access[:href].include?("nla.gov.au")
      url += copy_access[:href].to_s
    elsif related_access.present? && related_access[:href].include?("nla.gov.au")
      url += related_access[:href].to_s
    end

    url
  end
end
