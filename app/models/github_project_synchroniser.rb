class GithubProjectSynchroniser
  # Takes an array of repo names and loops over it, grabbing them from github and creating a project
  # record (if it doesn't already exist), populating as much information as it can from that repository.
  def self.create_from_repos repo_names
    array = []
    repo_names.each do |name|
      array << repo = Github.get_repo(name)
      Project.where(github_identifier: repo.full_name).first_or_create do |r|
        r.title = repo.name
        r.state = "Under Development"
        r.github_identifier = repo.full_name
        r.description = repo.description
      end
    end
    array
  end
end