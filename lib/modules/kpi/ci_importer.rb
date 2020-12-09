# frozen_string_literal: true

module Kpi::CiImporter
  # TODO - Not sure how to query Travis
  def self.exchange_token
    endpoint = 'https://api.travis-ci.org/auth/github'
    response = HTTParty.post(
      endpoint,
      basic_auth: Github::CLIENT_CREDENTIALS,
      query: {
        'accept': 'application/vnd.travis-ci.2.1+json'
      },
      headers: { 'User-Agent': 'Labs' }
    )
  end
end
