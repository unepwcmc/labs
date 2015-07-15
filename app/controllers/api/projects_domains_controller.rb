class Api::ProjectsDomainsController < ApplicationController
  def upload_model
    json = JSON.parse(request.body.read)

    Domain.add_domain(json)

    render json: json
  end
end
