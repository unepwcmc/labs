class KpisController < ApplicationController
  def index
  end

  def kpi_endpoint
    render json: Kpi.instance
  end

  def kpi_poll
    render json: Kpi.instance.updated_at
  end
end