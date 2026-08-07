# frozen_string_literal: true

module RequestHelper
  def items_issues_in_use(holding)
    if holding["checkedOutItems"].present?
      format_items_in_use(holding)
    end
  end

  def items_issues_held(holding)
    issues = holding["holdingsStatements"].dup
    merged_issues = issues.map do |statement|
      merge_statements_and_notes(statement)
    end
    compact_merged_array(merged_issues)
  end

  def supplements(holding)
    sups = holding["holdingsStatementsForSupplements"].dup
    merged_sups = sups&.map do |statement|
      merge_statements_and_notes(statement)
    end
    compact_merged_array(merged_sups)
  end

  def indexes(holding)
    indexes = holding["holdingsStatementsForIndexes"].dup
    merged_idx = indexes&.map do |statement|
      merge_statements_and_notes(statement)
    end

    compact_merged_array(merged_idx)
  end

  def merge_statements_and_notes(statements)
    compact_merged_array([statements["statement"], statements["note"]])
  end

  def compact_merged_array(merged)
    merged&.compact_blank.presence
  end

  def pickup_location_text(item)
    if pickup_location_code(item).start_with? "MRR"
      link = link_to "Main Reading Room", "https://www.library.gov.au/visit/reading-rooms/main-reading-room"
      t("requesting.collect_from.base", link: link, location: ", Ground Floor")
    elsif pickup_location_code(item).start_with? "SCRR"
      link = link_to "Special Collections Reading Room", "https://www.library.gov.au/visit/reading-rooms/special-collections-reading-room"
      t("requesting.collect_from.base", link: link, location: "")
    else
      link = link_to "Newspapers and Family History Zone", "https://www.library.gov.au/visit/reading-rooms/main-reading-room/newspapers-and-family-history-zone"
      t("requesting.collect_from.base", link: link, location: " in the Main Reading Room, Ground Floor")
    end
  end

  def pickup_location_img(item)
    if pickup_location_code(item).start_with? "MRR"
      image_tag "pickup-locations/NLA_006.png", class: "img-fluid"
    elsif pickup_location_code(item).start_with? "SCRR"
      image_tag "pickup-locations/NLA_003.png", class: "img-fluid"
    else
      image_tag "pickup-locations/NLA_011.png", class: "img-fluid"
    end
  end

  def pickup_location_code(item)
    item["pickupLocation"]["code"]
  end

  def access_condition_notes(holding)
    holding["notes"].select { |note| note["holdingsNoteType"] == "Restriction" }
  end

  def holding_notes(holding)
    holding["notes"].select { |note| note["holdingsNoteType"] != "Restriction" }
  end

  def shelving_title(holding)
    holding["shelvingTitle"]
  end

  def format_items_in_use(holding)
    holding["checkedOutItems"].map do |item|
      concatenated = "#{item["enumeration"]} #{item["chronology"]} #{item["yearCaption"]}"
      concatenated.strip
    end
  end

  def request_item_link(item, document)
    if is_dfl_item?(item)
      url = dfl_request_url(document)
      link_to I18n.t("requesting.btn_dfl_request"), url, class: "btn btn-primary", target: "_top"
    elsif item["displayStatus"] == "In use"
      button_to I18n.t("requesting.btn_in_use"), "#", target: "_top", class: "btn btn-primary", disabled: true
    elsif item["requestable"]
      holdings_id = item["holdingsRecordId"]
      item_id = item["id"]
      link_to I18n.t("requesting.btn_select"), solr_document_request_new_path(solr_document_id: document.id, holdings: holdings_id, item: item_id), class: "btn btn-primary", target: "_top"
    end
  end

  def dfl_request_url(document)
    config = Rails.application.config_for(:catalogue)
    base = config&.[](:reftracker_base_url)
    Rails.logger.info "DFL url: base=#{base.inspect}"
    return "#" unless base

    params = dfl_request_params(document).map { |k, v| "#{k}=#{ERB::Util.url_encode(v)}" }.join("&")
    "#{base}?#{params}"
  end

  def dfl_request_params(document)
    {
      key: "Access*Request",
      qnudftb17: solr_document_url(document),
      qnudftb11: extract_bibid(document),
      bbttl: document.first("title_tsim") || "",
      bbaut: document.first("author_display") || "",
      bbpd: document.first("pub_date") || "",
      clname: user_name_display
    }
  end

  def user_name_display
    user = respond_to?(:current_user) ? current_user : helpers.current_user
    return "" unless user

    "#{user.first_name} #{user.last_name}"
  end

  def extract_bibid(document)
    folio_id = document.first("folio_instance_id_ssim")
    return folio_id unless folio_id&.length == 10

    folio_id[2..]
  end
end
