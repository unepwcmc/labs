class Github
  def initialize
    @repos
  end

  # Returns an array of hashes of all (public so far) unepwcmc repositories with the first element as a hash of link header info
  # Pass in a page number for github pagination, defaults to 1

  CLIENT_CREDENTIALS = "client_id=#{Rails.application.secrets.github_key}&client_secret=#{Rails.application.secrets.github_secret}"

  def get_all_repos page = 1
    url = "#{Rails.application.secrets.github_api_base_url}orgs/unepwcmc/repos?#{CLIENT_CREDENTIALS}&page=#{page}"
    response = HTTParty.get(url, headers: {"User-Agent" => "Labs"})
    repos_array = JSON.parse(response.body).map { |repo| OpenStruct.new(repo) }
    @repos = repos_array.unshift(parse_link_headers(response.headers['link']))
  end

  # Takes a repo name and returns its information in an openstruct hash
  def get_single_repo name
    url = "#{Rails.application.secrets.github_api_base_url}repos/unepwcmc/#{name}?#{CLIENT_CREDENTIALS}"
    response = HTTParty.get(url, headers: {"User-Agent" => "Labs"})
    OpenStruct.new(JSON.parse(response.body))
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
