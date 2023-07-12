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
end
