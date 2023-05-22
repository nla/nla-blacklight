module RequestHelper
  def recent_item_issue_held(holding)
    if holding["holdingsStatements"].size > 1
      merge_statements_and_notes(holding["holdingsStatements"].last)
    else
      []
    end
  end

  def items_issues_held(holding)
    merged = []

    # remove the last statement because it would've already been displayed as the
    # recent item/issue held
    issues = holding["holdingsStatements"].dup
    if issues.size > 1
      issues.pop
    end
    issues.each do |statement|
      merged << merge_statements_and_notes(statement)
    end

    compact_merged_array(merged)
  end

  def supplements(holding)
    merged = []

    holding["holdingsStatementsForSupplements"].each do |statement|
      merged << merge_statements_and_notes(statement)
    end

    compact_merged_array(merged)
  end

  def indexes(holding)
    merged = []

    holding["holdingsStatementsForIndexes"].each do |statement|
      merged << merge_statements_and_notes(statement)
    end

    compact_merged_array(merged)
  end

  def merge_statements_and_notes(statements)
    merged = []

    merged << statements["statement"]
    merged << statements["note"]

    compact_merged_array(merged)
  end

  def compact_merged_array(merged)
    if merged.present?
      merged.reject(&:empty?)
    else
      []
    end
  end

  def pickup_location_text(item)
    if pickup_location_code(item).start_with? "MRR"
      link = link_to "Main Reading Room", "https://www.nla.gov.au/reading-rooms/main"
      t("requesting.collect_from.base", link: link, location: "Ground Level")
    elsif pickup_location_code(item).start_with? "SCRR"
      link = link_to "Special Collections Reading Room", "https://www.nla.gov.au/reading-rooms/special-collections"
      t("requesting.collect_from.base", link: link, location: "Level 1")
    else
      link = link_to "Newspapers and Family History", "https://www.nla.gov.au/reading-rooms/main/newspapers-and-family-history"
      t("requesting.collect_from.base", link: link, location: "Main Reading Room, Ground Level")
    end
  end

  def pickup_location_img(item)
    if pickup_location_code(item).start_with? "MRR"
      image_tag "pickup-locations/main_reading_room.jpeg", class: "img-fluid"
    elsif pickup_location_code(item).start_with? "SCRR"
      image_tag "pickup-locations/special_collections.jpeg", class: "img-fluid"
    else
      image_tag "pickup-locations/newspapers_and_family_history_zone.jpg", class: "img-fluid"
    end
  end

  def pickup_location_code(item)
    item["pickupLocation"]["code"]
  end
end
