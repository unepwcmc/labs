# frozen_string_literal: true

module Kpi::SnykStatisticsImporter
  SNYK_CREDENTIALS = {
    'Authorization': "token #{Rails.application.secrets.snyk_token}"
  }.freeze

  SNYK_ENDPOINT = "https://snyk.io/api/v1/org/#{Rails.application.secrets.snyk_org_id}"

  def self.update_single_project(project)
    # Relies on existing vulnerabilities_per_project data being present
    existing_projects = Kpi.instance.project_breakdown
    svg = fetch_snyk_badge(project)

    if svg.response.code == '404'
      Rails.logger.info("Couldn't obtain SVG for #{project.title}")
    elsif svg.response.code == '200'
      unless existing_projects.find { |p| p[:project] == project.title }
        existing_projects.push(specific_vulnerabilities_per_project(project.title, svg))
      end
    else
      Rails.logger.info("Couldn't parse SVG for #{project.title}")
    end
    
    kpi_fields(existing_projects)
  end

  def self.specific_vulnerabilities_per_project(title, svg)
    { project: title, number: sanitise_text(Nokogiri::HTML(svg).text) }
  end

  def self.fetch_snyk_badge(project)
    snyk_badge_url = "https://snyk.io/test/github/#{project.github_identifier}/badge.svg"

    begin
      HTTParty.get(snyk_badge_url)
    rescue Net::ReadTimeout
      Rails.logger.info("Request for #{project.title} timed out")
    end
  end

  def self.vulnerabilities_per_project
    projects = []
    missing_projects = []

    Project.find_each do |project|
      # TODO: - Snyk API access requires plan upgrade
      # project_name = project.github_identifier.split('/').last
      # project_path = "/project/#{project_name}/aggregated-issues"
      # response = HTTParty.post(
      #   SNYK_ENDPOINT + project_path,
      #   headers: SNYK_CREDENTIALS
      # )
      # next if response.response.code == '404'
      # JSON.parse(response.body)

      ## Slow and not very reliable workaround - parsing the badge number generated by Snyk for each project (which is free)
      ## Like with GitHub, only takes into account public repos
      svg = fetch_snyk_badge(project)

      if svg.response.code == '404'
        missing_projects << project.id
        projects << { project: project.title, number: 'Unknown' }
        next
      end

      Rails.logger.info("Successfully fetched SVG for #{project.title}")

      projects << specific_vulnerabilities_per_project(project.title, svg)
    end

    Rails.logger.info("#{missing_projects.length} projects were unaccounted for")
    kpi_fields(projects)
  end

  def self.sanitise_text(text)
    text.squish.gsub("\n", '').gsub("vulnerabilities", '').chars
        .each_slice(text.length / 2).map(&:join).first.to_i
  end

  def self.kpi_fields(projects)
    { projects: projects, vulnerability_hash: sort_into_hash(projects) }
  end

  def self.sort_into_hash(projects_array)
    no_vulnerabilities_count = 0
    fairly_secure_count = 0
    insecure_count = 0
    unknown_count = 0

    projects_array.each do |project|
      if project[:number].is_a?(Numeric)
        if project[:number] == 0
          no_vulnerabilities_count += 1
        elsif project[:number].positive? && project[:number] < 10
          fairly_secure_count += 1
        else
          insecure_count += 1
        end
      else
        unknown_count += 1
      end
    end

    {
      no_vulnerabilities: no_vulnerabilities_count,
      fairly_secure: fairly_secure_count,
      insecure: insecure_count,
      unknown: unknown_count
    }
  end
end
