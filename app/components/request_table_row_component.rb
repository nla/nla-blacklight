# frozen_string_literal: true

class RequestTableRowComponent < ViewComponent::Base
  with_collection_parameter :request

  def initialize(request)
    unless request[:request].nil?
      details = JSON.parse(request[:request].to_json, object_class: OpenStruct)
      @request_details = RequestDetail.new(details)
    end
  end

  def render?
    @request_details.present?
  end

  def link_to_record
    record_id = @request_details.record_id
    if record_id.present?
      helpers.link_to record_link_text, helpers.solr_document_path(record_id), class: "record-title"
    else
      # this should never happen, but in case a record is deleted from the index
      # :nocov:
      record_link_text
      # :nocov:
    end
  end

  def record_link_text
    link_text = @request_details.title
    link_text += " / #{@request_details.callNumber}" if @request_details.callNumber.present?
    link_text += " / #{@request_details.enumeration}" if @request_details.enumeration.present?
    link_text
  end
end
