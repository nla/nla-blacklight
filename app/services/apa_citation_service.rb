# frozen_string_literal: true

class ApaCitationService
  def initialize(document)
    @document = document
  end

  def cite
    result = []

    result << cite_authors
    result << "(#{@document.first("pub_date_ssim")})." if @document.first("pub_date_ssim").present?
    result << "<em>#{@document.first("title_tsim")}</em>."
    result << cite_publisher
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
    "#{cited_authors.join(" & ")}."
  end

  def cite_publisher
    cited_publisher = ""

    publisher = @document.publisher
    if publisher.present?
      publication_place = @document.publication_place
      cited_publisher += if publication_place.present?
        "#{publication_place} : #{publisher}"
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
