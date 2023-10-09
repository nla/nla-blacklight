# frozen_string_literal: true

class Description
  def initialize(document)
    @document = document
  end

  def value
    date_fields_array = @document.description_date
    description_fields_array = @document.description_fields
    if date_fields_array.present?
      date_fields_array.map do |s|
        s.gsub!(/[, .\\;]*$|^[, .\/;]*/, "") || s
      end
      if description_fields_array.present?
        date_fields_array.concat(description_fields_array)
      end
      date_fields_array.compact_blank.presence
    elsif description_fields_array.present?
      description_fields_array.compact_blank.presence
    end
  end
end
