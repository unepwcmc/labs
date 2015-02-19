class Github
  # Returns an array of hashes of all (public so far) unepwcmc repositories
  def self.repos
    response = HTTParty.get("https://api.github.com/orgs/unepwcmc/repos?client_id=#{Rails.application.secrets.github_key}&client_secret=#{Rails.application.secrets.github_secret}", headers: {"User-Agent" => "Labs"})
    JSON.parse(response.body).map { |repo| OpenStruct.new(repo) }
  end

  # Takes a repo name and returns its information in an openstruct hash
  def self.get_repo name
    response = HTTParty.get("https://api.github.com/repos/unepwcmc/#{name}?client_id=#{Rails.application.secrets.github_key}&client_secret=#{Rails.application.secrets.github_secret}", headers: {"User-Agent" => "Labs"})
    OpenStruct.new(JSON.parse(response.body))
  end
end
