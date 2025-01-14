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
    holdings_id = item["holdingsRecordId"]
    item_id = item["id"]

    if item["displayStatus"] == "In use"
      button_to I18n.t("requesting.btn_in_use"), "#", target: "_top", class: "btn btn-primary", disabled: true
    elsif item["requestable"]
      link_to I18n.t("requesting.btn_select"), solr_document_request_new_path(solr_document_id: document.id, holdings: holdings_id, item: item_id), class: "btn btn-primary", target: "_top"
    end
  end
end
