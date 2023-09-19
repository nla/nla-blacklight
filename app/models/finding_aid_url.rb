# frozen_string_literal: true

class FindingAidUrl
  def initialize(marc_rec)
    @marc_rec = marc_rec
  end

  def value
    sub_z3 = MarcDerivedField.instance.derive(@marc_rec, "856z3u", {alternate_script: false, separator: "--"})
    sub_z3&.each do |url|
      values = url.split("--")
      if values[0].downcase.include?("finding aid")
        return values[1]
      end
    end
  end
end
