# frozen_string_literal: true

class Access
  def initialize(document)
    @document = document
  end

  def copy_access_urls
    @copy_access_urls ||= get_copy_access_urls
  end

  def map_search_urls
    @map_search_urls ||= get_map_search_urls
  end

  def online_access_urls
    @online_access_urls ||= get_online_access_urls
  end

  def related_access_urls
    @related_access_urls ||= get_related_access_urls
  end

  def has_eresources?
    @has_eresources ||= determine_has_eresources
  end

  private

  def get_copy_access_urls
    elements = get_marc_datafields_from_xml("//datafield[@tag='856' and (@ind2='1' or (@ind2!='0' and @ind2!='2'))]")
    make_url(elements)
  end

  def get_map_search_urls
    url = MapSearchService.new.determine_url(id: @document.id, format: @document.fetch("format", nil))
    [url] if url.present?
  rescue KeyError
    Rails.logger.info "Record #{@document.id} has no 'format'"
    nil
  end

  def get_online_access_urls
    elements = get_marc_datafields_from_xml("//datafield[@tag='856' and @ind2='0']")
    make_url(elements)
  end

  def get_related_access_urls
    elements = get_marc_datafields_from_xml("//datafield[@tag='856' and @ind2='2']")
    make_url(elements)
  end

  private

  def determine_has_eresources
    eresource_urls = []

    online_access_urls&.each do |url|
      eresource_urls << url if Eresources.new.known_url(url[:href]).present?
    end

    if map_search_urls.present?
      eresource_urls << map_search_urls&.first if Eresources.new.known_url(map_search_urls&.first).present?
    end

    copy_access_urls&.each do |url|
      eresource_urls << url if Eresources.new.known_url(url[:href]).present?
    end

    related_access_urls&.each do |url|
      eresource_urls << url if Eresources.new.known_url(url[:href]).present?
    end

    eresource_urls.compact_blank.present?
  end

  def get_marc_datafields_from_xml(xpath)
    @document.marc_xml.xpath(xpath).presence
  end

  def make_url(elements)
    if elements.present?
      urls = []
      elements.each do |el|
        url_hash = {}
        el.children.each do |subfield|
          subfield_code = subfield.attribute("code").value
          if subfield_code == "3" || subfield_code == "z"
            url_hash[:text] = subfield.text if url_hash[:text].nil?
          elsif subfield_code == "u"
            url_hash[:href] = subfield.text
          end
        end
        if url_hash[:text].nil?
          url_hash[:text] = url_hash[:href]
        end
        urls << url_hash unless url_hash[:href].nil?
      end
      urls.compact_blank.presence
    end
  end
end
