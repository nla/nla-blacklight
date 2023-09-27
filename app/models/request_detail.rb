# frozen_string_literal: true

class RequestDetail
  include ActiveModel::Model
  include Blacklight::Configurable

  attr_reader :details, :record_id, :date

  delegate :requestId, :loan, :requestDate, :title, :patronComments, :instanceId, :yearCaption, :enumeration, :chronology, :callNumber, :status, :pickupServicePoint, :cancellationComment, :cancellationReason, :itemCategory, to: :details

  def initialize(details)
    @details = details
    @date ||= Time.zone.parse(requestDate)
    @record_id ||= fetch_record_id
  end

  def request_date
    @date.strftime("%-d %B %Y")
  end

  def request_time
    @date.strftime("%I:%M:%S%P")
  end

  def partial_name
    if itemCategory == "manuscript"
      "manuscripts"
    elsif itemCategory == "journal"
      "serials"
    elsif itemCategory == "map"
      "maps"
    else
      "monographs"
    end
  end

  private

  def fetch_record_id
    if @details.instanceId.present?
      Rails.cache.fetch("request_record_id/#{@details.instanceId}", expires_in: 15.minutes) do
        search_service = Blacklight.repository_class.new(blacklight_config)
        response = search_service.search(
          q: "folio_instance_id_ssim:\"#{@details.instanceId}\"",
          fl: "id",
          sort: "score desc",
          rows: 1
        )
        if response.present? && response["response"].present?
          doc = response["response"]["docs"].first
          doc.present? ? doc["id"] : nil
        end
      end
    end
  end
end
