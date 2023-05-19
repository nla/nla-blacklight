# frozen_string_literal: true

require "faraday"

class RequestController < ApplicationController
  include Blacklight::Searchable

  before_action :authenticate_user!
  before_action :request_params
  before_action :set_document, only: [:new, :create, :show]

  def show
  end

  def new
    @instance_id = request_params[:instance]
    @holdings_id = request_params[:holdings]
    @item_id = request_params[:item]
    @holding, @item = cat_services_client.get_holding(instance_id: @instance_id, holdings_id: @holdings_id, item_id: @item_id)

    @request = Request.new(instance_id: @instance_id, holdings_id: @holdings_id, item_id: @item_id)
  end

  def create
    instance_id = request_params[:request][:instance_id]
    holdings_id = request_params[:request][:holdings_id]
    item_id = request_params[:request][:item_id]
    @holding, @item = cat_services_client.get_holding(instance_id: instance_id, holdings_id: holdings_id, item_id: item_id)
    @create_response = cat_services_client.create_request(requester: current_user.folio_id, request: request_params[:request])
  end

  private

  def cat_services_client
    @catalogue_services_client ||= CatalogueServicesClient.new
  end

  def set_document
    _deprecated_response, @document = search_service.fetch(request_params[:solr_document_id])
  end

  def request_params
    params.permit(:solr_document_id, :instance, :holdings, :item, request: [:instance_id, :holdings_id, :item_id, :year, :enumeration, :chronology, :notes])
  end
end
