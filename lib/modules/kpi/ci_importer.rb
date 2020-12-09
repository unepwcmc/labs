# frozen_string_literal: true

module Kpi::CiImporter
  # TODO - Not sure how to query Travis
  def exchange_token
    endpoint = 'https://api.travis-ci.org/auth/github'
    response = HTTParty.post(
      endpoint,
      query: {
        'accept': 'application/vnd.travis-ci.2.1+json',
        'github_token': Rails.application.secrets.github_secret
      },
      headers: { 'User-Agent': 'Labs' }
    )
  end
end
