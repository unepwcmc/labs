# frozen_string_literal: true

module Kpi::CiImporter
  TRAVIS_ENDPOINT = 'https://api.travis-ci.com/repos'.freeze
  
  # Note - only finds 'active' projects on Travis
  def self.find_projects_with_ci
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
    travis_projects = JSON.parse(response.body)['repos'].map { |project| project['slug'] }
    projects_with_ci = travis_projects.select do |identifier|
      Project.pluck(:github_identifier).include?(identifier)
    end.count

    ((projects_with_ci.to_f / Project.count) * 100).round(2)
  end
end