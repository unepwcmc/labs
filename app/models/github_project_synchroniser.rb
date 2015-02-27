class GithubProjectSynchroniser
  def initialize repos
    @repo_names = repos
  end

  # Takes an array of repo names and loops over it, grabbing them from github and creating a project
  # record (if it doesn't already exist), populating as much information as it can from that repository.
  # Returns an array of the projects to loop through for errors
  def run
    @repo_names.map! { |name|
      github = Github.new
      repo = github.get_single_repo(name)

      Project.where(github_identifier: repo.full_name).first_or_create do |r|
        r.title = repo.name
        r.state = "Under Development"
        r.github_identifier = repo.full_name
        r.description = repo.description.presence || '(empty)'
      end
    }.compact
  end
end
