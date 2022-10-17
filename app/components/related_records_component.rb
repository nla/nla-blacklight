class RelatedRecordsComponent < Blacklight::MetadataFieldComponent
  def initialize(field:, layout: nil, show: false)
    super
  end

  def value
    @field.values.first
  end

  def render?
    value.present? && value.in_collection?
  end
end
