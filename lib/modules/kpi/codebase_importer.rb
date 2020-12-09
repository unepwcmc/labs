# frozen_string_literal: true

module Kpi::CodebaseImporter
  CODEBASE_CREDENTIALS = { 
    username: Rails.application.secrets.codebase_api_username, 
    password: Rails.application.secrets.codebase_api_key
  }.freeze

  CODEBASE_ENDPOINT = 'https://api3.codebasehq.com'.freeze

  def self.bugs_backlog_size
    url = CODEBASE_ENDPOINT + '/bits-and-bugs/tickets'
    response = HTTParty.get(
      url,
      basic_auth: CODEBASE_CREDENTIALS,
      headers: {
        'Accept': 'application/xml',
        'Content-type': 'application/xml'
      } 
    )
    tickets = Hash.from_xml(response.body)['tickets']

    tickets.select do |ticket| 
      ticket['priority']['name'] == ('High' || 'Critical') && ticket['status']['name'] != 'Completed'
    end.count
  end
end