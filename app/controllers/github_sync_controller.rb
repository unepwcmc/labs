class GithubSyncController < ApplicationController
  def index
    @page = params[:page]
    github = Github.new
    repos = github.get_all_repos(@page)

    existing_repo_names = Project.pluck(:github_identifier)
    
    @link_headers = repos.shift
    @repos = repos.reject{ |repo| existing_repo_names.include?(repo.full_name) }
  end

  def sync
    github_sync = GithubProjectSynchroniser.new(params[:repos])
    repos = github_sync.run

    if contains_invalid_repository? repos
      github = Github.new
      @page = params[:page]
      repositories = github.get_all_repos(@page)

      @link_headers = repositories.shift
      @repos = repositories
      @errored_repos = repos.select { |r| r.errors }
      render :index
    else
      redirect_to projects_path, notice: "All projects were created successfully!"
    end
  end

  private
    def contains_invalid_repository? repos
      repos.find { |r| !r.valid? }
    end
end
