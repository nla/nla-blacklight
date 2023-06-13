# frozen_string_literal: true
class HarvardCitationService
  def initialize(document)
    @document = document
  end

  def cite
    result = []

    result << cite_authors
    result << cite_pubdate
    result << "<em>#{@document.first("title_tsim")}</em>."
    result << cite_publisher
    result << cite_url

    result.join(" ")
  end

  def cite_authors
    authors = []

    author = @document.first("author_with_relator_ssim")
    authors << author.to_s if author.present?

    other_authors = @document.other_authors
    other_authors.each do |other|
      authors << other.to_s
    end

    "#{authors.join(" & ")}."
  end

  def cite_pubdate
    pub_date = @document.first("pub_date_ssim")
    if pub_date.present?
      "#{@document.first("pub_date_ssim")},"
    else
      "n.d., "
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
