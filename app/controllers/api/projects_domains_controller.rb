class Api::ProjectsDomainsController < ApplicationController
  def upload_model
    render json: JSON.parse(request.body.read)
  end
end
