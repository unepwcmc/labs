class GithubSyncController < ApplicationController
  def index
    @repos = Github.repos
  end

  def sync
    Project.create_from_repos params[:repos]
    redirect_to projects_path, notice: "Your projects have been created from the information in their github repositories!"
  end
end
