class Github
  def initialize
    @repos
  end

  # Returns an array of hashes of all (public so far) unepwcmc repositories with the first element as a hash of link header info
  def get_all_repos
    response = HTTParty.get("https://api.github.com/orgs/unepwcmc/repos?client_id=#{Rails.application.secrets.github_key}&client_secret=#{Rails.application.secrets.github_secret}", headers: {"User-Agent" => "Labs"})
    repos_array = JSON.parse(response.body).map { |repo| OpenStruct.new(repo) }
    @repos = repos_array.unshift(parse_link_headers(response.headers['link']))
  end

  # Takes a repo name and returns its information in an openstruct hash
  def get_single_repo name
    response = HTTParty.get("https://api.github.com/repos/unepwcmc/#{name}?client_id=#{Rails.application.secrets.github_key}&client_secret=#{Rails.application.secrets.github_secret}", headers: {"User-Agent" => "Labs"})
    OpenStruct.new(JSON.parse(response.body))
  end

  private
    # Parses github link header string into a sensible hash format
    def parse_link_headers headers
      array = headers.delete(' ').gsub(/[\"\\\<\>]/, '').gsub(/rel=/, '').split(',').map {|e| e.split(';').reverse }
      pages = []
      array.each { |e| pages << ["#{e.first}_page", e[1].last] }
      Hash[array.zip(pages).flatten!(1)]
    end
end
