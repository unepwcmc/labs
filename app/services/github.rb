class Github
  def initialize
    @repos
  end

  # Returns an array of hashes of all (public so far) unepwcmc repositories with the first element as a hash of link header info
  # Pass in a page number for github pagination, defaults to 1
  CLIENT_CREDENTIALS = { username: Rails.application.secrets.github_key, password: Rails.application.secrets.github_secret }

  def get_all_repos page = 1
    url = "#{Rails.application.secrets.github_api_base_url}orgs/unepwcmc/repos?page=#{page}"
    response = HTTParty.get(url, basic_auth: CLIENT_CREDENTIALS, headers: {"User-Agent" => "Labs"})
    repos_array = JSON.parse(response.body).map { |repo| OpenStruct.new(repo) }
    @repos = repos_array.unshift(parse_link_headers(response.headers['link']))
  end

  # Takes a repo name and returns its information in an openstruct hash
  def get_single_repo name
    url = "#{Rails.application.secrets.github_api_base_url}repos/unepwcmc/#{name}"
    response = HTTParty.get(url, basic_auth: CLIENT_CREDENTIALS, headers: {"User-Agent" => "Labs"})
    OpenStruct.new(JSON.parse(response.body))
  end

  def get_rails_version repo
    url = "#{Rails.application.secrets.github_api_base_url}repos/unepwcmc/#{repo}/contents/Gemfile"
    response = HTTParty.get(url, basic_auth: CLIENT_CREDENTIALS, headers: {"User-Agent" => "Labs"})
    return '' if response.body.match(/Not\sFound/)
    content = Base64.decode64(JSON.parse(response.body)["content"])
    content.match(/gem 'rails',\s'(~>\s)?(\d\.[\d+|\.]*)'/).try(:captures).try(:last) || ''
  end

  def get_ruby_version repo
    url = "#{Rails.application.secrets.github_api_base_url}repos/unepwcmc/#{repo}/contents/.ruby-version"
    response = HTTParty.get(url, basic_auth: CLIENT_CREDENTIALS, headers: {"User-Agent" => "Labs"})
    return '' if response.body.match(/Not\sFound/)
    Base64.decode64(JSON.parse(response.body)["content"]).delete!("\n")
  end

  private
    # Parses github link header string into a sensible hash format
    def parse_link_headers headers
      array = headers.delete(' ').gsub(/[\"\\\<\>]/, '').gsub(/rel=/, '').split(',').map {|e| e.split(';').reverse }
      pages = []
      array.each { |e| pages << ["#{e.first}_page", e[1].last.to_i] }
      Hash[array.zip(pages).flatten!(1)]
    end
end
