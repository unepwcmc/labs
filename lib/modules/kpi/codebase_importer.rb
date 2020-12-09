# frozen_string_literal: true

module Kpi::CodebaseImporter
  CODEBASE_CREDENTIALS = { 
    username: Rails.application.secrets.codebase_api_username, 
    password: Rails.application.secrets.codebase_api_key
  }.freeze

  CODEBASE_ENDPOINT = 'https://api3.codebasehq.com'.freeze

  def self.bugs_backlog_size
    ticket_count = 0
    page = 1
    response = codebase_query(page)
    
    until response.response.code == '404'
      response = codebase_query(page)
      page += 1
      tickets = Hash.from_xml(response.body)['tickets']
      ticket_count += tickets.select do |ticket| 
        ( ticket['priority']['name'] == 'High' || 
          ticket['priority']['name'] == 'Critical') && 
        ticket['status']['name'] != 'Completed'
      end.count
    end

    ticket_count
  end

  def self.codebase_query(page)
    HTTParty.get(
      CODEBASE_ENDPOINT + '/bits-and-bugs/tickets',
      basic_auth: CODEBASE_CREDENTIALS,
      query: { 'page': page },
      headers: {
        'Accept': 'application/xml',
        'Content-type': 'application/xml'
      } 
    )
  end
end
