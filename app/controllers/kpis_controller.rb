class KpisController < ApplicationController
  def index
    render json: Kpi.instance
  end
end