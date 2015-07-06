class ProjectsController < ApplicationController
  include Errors
  before_action :authenticate_user!, :except => [:index]
  before_action :available_developers, :only => [:new, :edit]
  before_action :available_employees, :only => [:new, :edit]
  # GET /projects
  # GET /projects.json

  rescue_from HasInstances, with: :rescue_has_instances_exception

  respond_to :html, :json

  def index

    @projects = params[:search].present? ?
        Project.search(params[:search]).order("created_at DESC") :
        Project.order("created_at DESC")

    @projects = @projects.published unless user_signed_in?

    respond_with(@projects)
  end

  def list
    respond_to do |format|
      format.html { html_list }
      format.csv { csv_list }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
    @instances = @project.project_instances

    @comments = @project.comments.order(:created_at)
    @comment = Comment.new

    @master_projects = @project.master_projects.select("title, projects.id")
    @sub_projects = @project.sub_projects.select("title, projects.id")

    respond_with(@project)
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_with(@project)
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_with(@project) do |format|
      if @project.save
        format.html { redirect_to @project, :notice => 'Project was successfully created.' }
      else
        format.html {
          available_developers
          available_employees
          render :action => "new"
        }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_with(@project) do |format|
      if @project.update_attributes(project_params)
        format.html { redirect_to @project, :notice => 'Project was successfully updated.' }
      else
        format.html {
          available_developers
          available_employees
          render :action => "edit"
        }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    raise HasInstances unless @project.project_instances.empty?
    @project.destroy
    flash[:notice] = 'Project was successfully deleted.'

    respond_with(@project)
  end

  private

  def available_developers
    devs = Project.pluck(:developers).flatten
    users = User.pluck(:name)
    @developers = (devs + users).compact.uniq.sort || []
  end

  def available_employees
    @employees = HTTParty.get('http://unep-wcmc.org/api/employees.json')
    if @employees.code != 200
      @employees = []
    end
  end

  def project_params
    params.require(:project).permit(:developers_array, :title,
      :description, :url, :github_id, :pivotal_tracker_id,
      :toggl_id, :deadline, :screenshot, :state,
      :github_identifier, :dependencies, :internal_clients_array, :current_lead,
      :hacks, :external_clients_array, :project_leads_array, :pdrive_folders_array,
      :dropbox_folders_array, :pivotal_tracker_ids_array, :trello_ids_array, :expected_release_date,
      :rails_version, :ruby_version, :postgresql_version, :other_technologies_array, :published,
      :internal_description, :background_jobs, :cron_jobs, :user_access,
      master_sub_relationship_attributes: [:id, :master_project_id, :_destroy],
      sub_master_relationship_attributes: [:id, :sub_project_id, :_destroy]
    )
  end

  def rescue_has_instances_exception(exception)
    redirect_to :back, alert: "This project has project instances. Delete its project instances first"
  end

  def html_list
    @projects = Project.includes(:project_instances, :reviews).order(:title, 'reviews.updated_at')
    gon.push({
      :states => Project.pluck_field(:state),
      :rails_versions => Project.pluck_field(:rails_version),
      :ruby_versions => Project.pluck_field(:ruby_version),
      :postgresql_versions => Project.pluck_field(:postgresql_version)
    })
  end

  def csv_list
    project_export = if params[:scope] == 'species'
      SpeciesProjectsExport.new
    else
      ProjectsExport.new
    end
    send_file(project_export.export, type: 'text/csv')
  end

end
