class RequestController < ApplicationController
  include Blacklight::Searchable

  before_action :authenticate_user!
  before_action :set_document, only: [:new, :create, :show]

  def show
  end

  def new
    instance_id = params[:instance]
    holdings_id = params[:holdings]
    item_id = params[:item]
    @holding, @item = cat_services_client.get_holding(instance_id: instance_id, holdings_id: holdings_id, item_id: item_id)
  end

  def create
  end

  private

  def cat_services_client
    @catalogue_services_client ||= CatalogueServicesClient.new
  end

  def set_document
    _deprecated_response, @document = search_service.fetch(params[:solr_document_id])
  end
end
