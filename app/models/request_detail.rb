# frozen_string_literal: true

class RequestDetail
  include ActiveModel::Model
  include Blacklight::Configurable

  attr_reader :details

  delegate :instanceId, :title, :callNumber, :enumeration, :pickupServicePoint, :patronComments, :requestDate, to: :details

  def initialize(details)
    @details = details
  end

  def record_id
    @record_id ||= fetch_record_id
  end

  def request_date
    # requestDate.strftime("%FT%T")
    date.strftime("%-d %B %Y")
  end

  def request_time
    date.strftime("%I:%M:%S%P")
  end

  private

  def date
    @date ||= Time.zone.parse(requestDate)
  end

  def fetch_record_id
    if @details.instanceId.present?
      search_service = Blacklight.repository_class.new(blacklight_config)
      response = Rails.cache.fetch("#{@details.instanceId}_record", expires_in: 15.minutes) do
        search_service.search(
          q: "folio_instance_id_ssim:\"#{@details.instanceId}\"",
          fl: "id",
          sort: "score desc",
          rows: 1
        )
      end
      if response.present? && response["response"].present?
        doc = response["response"]["docs"].first
        doc.present? ? doc["id"] : nil
      end
    end
  end
end
