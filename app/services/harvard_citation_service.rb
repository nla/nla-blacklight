# frozen_string_literal: true
class HarvardCitationService
  def initialize(document)
    @document = document
  end

  def cite
    result = []

    author = @document.first("author_with_relator_ssim")
    result << "#{author}." if author.present?

    other_authors = @document.other_authors.first
    result << "#{other_authors}." if other_authors.present?

    pub_date = @document.first("pub_date_ssim")
    if pub_date.present?
      result << "#{@document.first("pub_date_ssim")},"
    else
      "n.d., "
    end

    title = @document.first("title_tsim")
    result << "<em>#{title}</em>"

    publisher = @document.first("publisher_tsim")
    result << publisher.to_s if publisher.present?

    copy_access = @document.copy_access.first
    related_access = @document.related_access.first
    if copy_access.present? && copy_access[:href].include?("nla.gov.au")
      result << copy_access[:href].to_s
    elsif related_access.present? && related_access[:href].include?("nla.gov.au")
      result << related_access[:href].to_s
    end

    result.join(" ")
  end
end
