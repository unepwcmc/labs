class Api::ProjectsDomainsController < ApplicationController
  before_action :authenticate

  def upload_model
    json = JSON.parse(request.body.read)

    Domain.add_domain(json)

    render json: json
  end

  private

  def authenticate
    token = request.headers['X-Authentication-Token']
    unless token == ENV['API_TOKEN']
      head status: :unauthorized
      return false
    end
  end
end
