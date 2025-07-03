# frozen_string_literal: true

require "faraday"

class RequestController < ApplicationController
  include Blacklight::Searchable
  include Blacklight::SearchContext

  before_action :authenticate_user!, only: [:new, :create, :success]
  before_action :request_params
  before_action :set_document
  before_action :check_request_limit, only: [:new, :success]

  def index
    # lazy loaded via Turboframes into the "Request this item" section of the catalogue record page
  end

  def new
    instance_id = @document.first("folio_instance_id_ssim")
    holdings_id = request_params[:holdings]
    item_id = request_params[:item]

    holding, item = CatalogueServicesClient.new.get_holding(instance_id: instance_id, holdings_id: holdings_id, item_id: item_id)

    @request_form = if item["itemCategory"] == "manuscript"
      "manuscripts"
    elsif item["itemCategory"] == "journal"
      "serials"
    elsif item["itemCategory"] == "map"
      "maps"
    elsif item["itemCategory"] == "picture"
      "picture"
    elsif item["itemCategory"] == "picture-series"
      "pictureseries"
    elsif item["itemCategory"] == "poster"
      "poster"
    elsif item["itemCategory"] == "poster-series"
      "posterseries"
    else
      "monographs"
    end

    @finding_aids_link = if @document.finding_aid_url.present?
      helpers.link_to I18n.t("requesting.collection_finding_aid"), @document.finding_aid_url, target: "_blank", rel: "noopener noreferrer"
    else
      I18n.t("requesting.collection_finding_aid")
    end

    @request = Request.new(instance_id: instance_id, holdings_id: holdings_id, item_id: item_id)
    @request.holding = holding
    @request.item = item
  end

  def create
    instance_id = @document.first("folio_instance_id_ssim")
    holdings_id = request_params[:request][:holdings_id]
    item_id = request_params[:request][:item_id]

    new_request = request_params[:request].to_h
    new_request[:instance_id] = instance_id

    cat_services_client = CatalogueServicesClient.new
    _holding, @item = cat_services_client.get_holding(instance_id: instance_id, holdings_id: holdings_id, item_id: item_id)
    cat_services_client.create_request(requester: current_user.folio_id, request: new_request)

    redirect_to action: :success, holdings: holdings_id, item: item_id
  end

  def success
    instance_id = @document.first("folio_instance_id_ssim")
    holdings_id = request_params[:holdings]
    item_id = request_params[:item]

    _, @item = CatalogueServicesClient.new.get_holding(instance_id: instance_id, holdings_id: holdings_id, item_id: item_id)

    if @item["pickupLocation"]["code"].start_with? "SCRR"
      @show_scrr = true
    end
  end

  private

  def set_document
    @document = search_service.fetch(request_params[:solr_document_id])
  end

  def request_params
    params.permit(:solr_document_id, :holdings, :item, request: [:instance_id, :holdings_id, :item_id, :year, :enumeration, :chronology, :notes])
  end

  def check_request_limit
    @met_request_limit = CatalogueServicesClient.new.request_limit_reached?(requester: current_user.folio_id)
  end
end
