# frozen_string_literal: true

module RequestHelper
  def items_issues_in_use(holding)
    if holding["checkedOutItems"].present?
      format_items_in_use(holding)
    end
  end

  def recent_item_issue_held(holding)
    if holding["holdingsStatements"].present?
      merge_statements_and_notes(holding["holdingsStatements"].last)
    end
  end

  def items_issues_held(holding)
    # remove the last statement because it would've already been displayed as the
    # recent item/issue held
    issues = holding["holdingsStatements"].dup
    if issues.size > 1
      issues.pop
    end
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
      link = link_to "Main Reading Room", "https://www.nla.gov.au/reading-rooms/main"
      t("requesting.collect_from.base", link: link, location: ", Ground Floor")
    elsif pickup_location_code(item).start_with? "SCRR"
      link = link_to "Special Collections Reading Room", "https://www.nla.gov.au/reading-rooms/special-collections"
      t("requesting.collect_from.base", link: link, location: ", First Floor")
    else
      link = link_to "Newspapers and Family History Zone", "https://www.nla.gov.au/reading-rooms/main/newspapers-and-family-history"
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

  def format_items_in_use(holding)
    holding["checkedOutItems"].map do |item|
      concatenated = "#{item["enumeration"]} #{item["chronology"]} #{item["yearCaption"]}"
      concatenated.strip
    end
  end
end
