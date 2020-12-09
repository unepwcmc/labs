# frozen_string_literal: true

module Kpi::CodebaseImporter
  CODEBASE_CREDENTIALS = {
    username: Rails.application.secrets.codebase_api_username,
    password: Rails.application.secrets.codebase_api_key
  }.freeze

  CODEBASE_ENDPOINT = 'https://api3.codebasehq.com'

  DEFAULT_TICKETS_HASH = {
    ticket_count: 0,
    severity: {
      critical: 0,
      high: 0,
      normal: 0,
      low: 0
    }
  }.freeze

  def self.bugs_backlog_size
    tickets_hash = DEFAULT_TICKETS_HASH.dup
    page = 1
    query = codebase_query(page)

    until query.response.code == '404'
      query = codebase_query(page)
      page += 1
      tickets = Hash.from_xml(query.body)['tickets']
      tickets.reject! { |ticket| ticket['status']['name'] == 'Completed' }
      tickets_hash[:ticket_count] += tickets.count

      tickets_hash[:severity].keys.each do |key|
        tickets.each do |ticket|
          if key.to_s == ticket['priority']['name'].downcase
            tickets_hash[:severity][key] += 1
          end
        end
      end
    end

    tickets_hash
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
