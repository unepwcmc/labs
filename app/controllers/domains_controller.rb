class DomainsController < ApplicationController
  respond_to :html, :json

  def index
    @domains = Domain.all
    respond_with(@domains)
  end

  def show
    @domain = Domain.find(params[:id])
    @model = @domain.models.first
    respond_with(@domain)
  end

  def edit
  end

  def new
  end

  def update
  end

  def create
  end

  def destroy
  end

  def select_model
    @model = Model.find(params[:model_id])

    render "domains/_data_container", layout: false
  end

end
