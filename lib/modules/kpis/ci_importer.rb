# frozen_string_literal: true

module Kpis::CiImporter
  TRAVIS_ENDPOINT = 'https://api.travis-ci.com/repos'.freeze
  
  # Note - only finds 'active' products on Travis
  def self.find_products_with_ci
    response = HTTParty.get(
      TRAVIS_ENDPOINT,
      query: {
        'active': 'true'
      },
      headers: { 
        'Accept': 'application/vnd.travis-ci.2.1+json',
        'User-Agent': 'MyClient/1.0.0',
        'Authorization': "token #{Rails.application.secrets.travis_token}"
       }
    )

    travis_products = nil
    max_retries = 3
    times_retried = 0

    # Sometimes the importer doesn't manage to reach the API properly
    begin
      travis_products = JSON.parse(response.body)['repos'].map { |product| product['slug'] }
    rescue JSON::ParserError
      if times_retried < max_retries
        times_retried += 1
        Rails.logger.info("Unexpected error with CI importer encountered. Retrying...")
        retry
      else
        Rails.logger.error("Max retries reached. Aborting...")
        travis_products = []
      end
    end

    travis_products.select do |identifier|
      Product.pluck(:github_identifier).include?(identifier)
    end.count
  end
end
