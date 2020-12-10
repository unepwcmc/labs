class KpisController < ApplicationController
  def index
    render json: Kpi.first
  end
end