# frozen_string_literal: true

class Github
  def initialize
    @repos
  end

  # Returns an array of hashes of all (public so far) unepwcmc repositories with the first element as a hash of link header info
  # Pass in a page number for github pagination, defaults to 1
  CLIENT_CREDENTIALS = { username: Rails.application.secrets.github_key, password: Rails.application.secrets.github_secret }.freeze

  def get_all_repos(page = 1)
    url = "#{Rails.application.secrets.github_api_base_url}orgs/unepwcmc/repos?page=#{page}"
    response = HTTParty.get(url, basic_auth: CLIENT_CREDENTIALS, headers: { 'User-Agent' => 'Labs' })
    repos_array = JSON.parse(response.body).map { |repo| OpenStruct.new(repo) }
    @repos = repos_array.unshift(parse_link_headers(response.headers['link']))
  end

  # Takes a repo name and returns its information in an openstruct hash
  def get_single_repo(name)
    url = "#{Rails.application.secrets.github_api_base_url}repos/unepwcmc/#{name}"
    response = HTTParty.get(url, basic_auth: CLIENT_CREDENTIALS, headers: { 'User-Agent' => 'Labs' })
    OpenStruct.new(JSON.parse(response.body))
  end

  def get_rails_version(repo)
    url = "#{Rails.application.secrets.github_api_base_url}repos/unepwcmc/#{repo}/contents/Gemfile"
    response = HTTParty.get(url, basic_auth: CLIENT_CREDENTIALS, headers: { 'User-Agent' => 'Labs' })
    return '' if response.body.match(/Not\sFound/)

    content = Base64.decode64(JSON.parse(response.body)['content'])
    content.match(/gem 'rails',\s'(~>\s)?(\d\.[\d+|\.]*)'/).try(:captures).try(:last) || ''
  end

  def get_ruby_version(repo)
    url = "#{Rails.application.secrets.github_api_base_url}repos/unepwcmc/#{repo}/contents/.ruby-version"
    response = HTTParty.get(url, basic_auth: CLIENT_CREDENTIALS, headers: { 'User-Agent' => 'Labs' })
    return '' if response.body.match(/Not\sFound/)

    Base64.decode64(JSON.parse(response.body)['content']).delete!("\n")
  end

  # Only looks at commits from master branch
  def self.import_commit_dates
    Product.find_each do |product|
      next if product.github_identifier.blank?

      url = "#{Rails.application.secrets.github_api_base_url}repos/#{product.github_identifier}/commits"
      response = HTTParty.get(
        url, 
        query: {
          'accept': 'application/vnd.github.v3+json',
          'since': "#{1.year.ago.strftime('%FT%TZ')}",
          'per_page': '1'
        },
        headers: { 
          'User-Agent': 'Labs',
          'Authorization': "token #{Rails.application.secrets.github_personal_access_token}"
        }
      )

      latest_commit_date = nil

      begin
        commit_hash = JSON.parse(response.body).first
        next if commit_hash.nil?
        latest_commit_date = commit_hash.dig('commit', 'author', 'date')
      rescue TypeError
        Rails.logger.info "#{product.title} has not been worked on in the past year or is not available"
        next
      end

      product.update_attribute(:last_commit_date, latest_commit_date.to_date)
      Rails.logger.info "#{product.title} has been successfully updated"
    end
  end

  private

  # Parses github link header string into a sensible hash format
  def parse_link_headers(headers)
    array = headers.delete(' ').gsub(/[\"\\\<\>]/, '').gsub(/rel=/, '').split(',').map { |e| e.split(';').reverse }
    pages = []
    array.each { |e| pages << ["#{e.first}_page", e[1].last.to_i] }
    Hash[array.zip(pages).flatten!(1)]
  end
end
