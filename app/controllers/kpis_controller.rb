class KpisController < ApplicationController
  def index
  end

  def kpi_endpoint
    render json: Kpi.instance
  end
end