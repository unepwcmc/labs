class Api::V1::ProductsDomainsController < ApplicationController
  before_action :authenticate

  def upload_model
    json = JSON.parse(request.body.read)

    Domain.add_domain(json)

    render json: json
  end

  private

  def authenticate
    token = request.headers['X-Authentication-Token']
    unless token == Rails.application.secrets.api_token
      head status: :unauthorized
      return false
    end
  end
end
