# frozen_string_literal: true

module Kpis::SnykStatisticsImporter
  # TODO: - Snyk API access requires plan upgrade
  # SNYK_CREDENTIALS = {
  #   'Authorization': "token #{Rails.application.secrets.snyk_token}"
  # }.freeze

  # SNYK_ENDPOINT = "https://snyk.io/api/v1/org/#{Rails.application.secrets.snyk_org_id}"

  def self.update_single_product(product)
    # Relies on existing vulnerabilities_per_product data being present
    existing_products = Kpi.instance.product_breakdown
    svg = fetch_snyk_badge(product)


    if svg.response.code == '404' || !svg
      Rails.logger.info("Couldn't obtain SVG for #{product.title}")
    elsif svg.response.code == '200'
      unless existing_products.find { |p| p[:product] == product.title }
        existing_products.push(specific_vulnerabilities_per_product(product.title, svg))
      end
    else
      Rails.logger.info("Couldn't parse SVG for #{product.title}")
    end
    
    kpi_fields(existing_products)
  end

  def self.vulnerabilities_per_product
    products = []
    missing_products = []

    Product.find_each do |product|
      # TODO: - Snyk API access requires plan upgrade
      # product_name = product.github_identifier.split('/').last
      # product_path = "/project/#{product_name}/aggregated-issues"
      # response = HTTParty.post(
      #   SNYK_ENDPOINT + project_path,
      #   headers: SNYK_CREDENTIALS
      # )
      # next if response.response.code == '404'
      # JSON.parse(response.body)

      ## Slow and not very reliable workaround - parsing the badge number generated by Snyk for each project (which is free)
      ## Only takes into account public repos
      svg = fetch_snyk_badge(product)


      if svg.response.code == '404' || !svg
        missing_products << product.id
        products << { product: product.title, number: 'Unknown' }
        next
      end

      Rails.logger.info("Successfully fetched SVG for #{product.title}")

      products << specific_vulnerabilities_per_product(product.title, svg)
    end

    Rails.logger.info("#{missing_products.length} products were unaccounted for")
    kpi_fields(products)
  end

  def self.sort_into_hash(products_array)
    vuln_hash = Hash.new(0)

    products_array.each do |product|
      if product[:number].is_a?(Numeric)
        if product[:number].zero?
          vuln_hash[:no_vulnerabilities_count] += 1
        elsif product[:number].positive? && product[:number] < 10
          vuln_hash[:fairly_secure_count] += 1
        else
          vuln_hash[:insecure_count] += 1
        end
      else
        vuln_hash[:unknown_count] += 1
      end
    end

    vuln_hash
  end

  def self.fetch_snyk_badge(product)
    snyk_badge_url = "https://snyk.io/test/github/#{product.github_identifier}/badge.svg"

    max_retries = 3
    times_retried = 0

    begin
      HTTParty.get(snyk_badge_url)
    rescue Net::ReadTimeout
      if times_retried < max_retries
        times_retried += 1
        Rails.logger.info("Request for #{product.title} timed out, #{times_retried}/#{max_retries}")
        retry
      else
        Rails.logger.info("Max retries exceeded, aborting")
        exit(1)
      end
    end
  end

  def self.sanitise_text(text)
    text.squish.gsub("\n", '').gsub("vulnerabilities", '').chars
        .each_slice(text.length / 2).map(&:join).first.to_i
  end

  def self.kpi_fields(products)
    { products: products, vulnerability_hash: sort_into_hash(products) }
  end

  def self.specific_vulnerabilities_per_product(title, svg)
    { product: title, number: sanitise_text(Nokogiri::HTML(svg).text) }
  end
end
