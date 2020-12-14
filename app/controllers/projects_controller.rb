# frozen_string_literal: true

class ProjectsController < ApplicationController
  include Errors
  before_action :authenticate_user!, :except => [:index]
  before_action :available_developers, :only => %i[new edit]
  before_action :available_designers, :only => %i[new edit]
  before_action :available_employees, :only => %i[new edit]
  before_action :find_project, only: %i[show edit update destroy]
  # GET /projects
  # GET /projects.json

  rescue_from HasInstances, with: :rescue_has_instances_exception

  respond_to :html, :json

  def index
    if user_signed_in? && params[:user]
      username = User.find(params[:user]).name
      @projects = Project.where("developers @> '{#{username}}'::text[] OR current_lead = '#{username}'")
    else
      @projects = params[:search].present? ?
          Project.search(params[:search]).order('created_at DESC') :
          Project.order('created_at DESC')

      @projects = @projects.published unless user_signed_in?
    end

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
    deprecated_resources = %i(pdrive_folders dropbox_folders pivotal_tracker_ids trello_ids)
    @no_deprecated_resources = deprecated_resources.all? do |res|
      @project.send(res).blank?
    end

    @instances = @project.project_instances

    @comments = @project.comments.order(:created_at)
    @comment = Comment.new

    @master_projects = @project.master_projects.select('title, projects.id')
    @sub_projects = @project.sub_projects.select('title, projects.id')

    respond_with(@project)
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new
    @project_status_options = project_status_options

    respond_with(@project)
  end

  # GET /projects/1/edit
  def edit
    @project_status_options = project_status_options
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_with(@project) do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
      else
        format.html do
          available_developers
          available_designers
          available_employees
          render action: 'new'
        end
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project_status_options = project_status_options

    respond_with(@project) do |format|
      if @project.update_attributes(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
      else
        format.html do
          available_developers
          available_designers
          available_employees
          render action: 'edit'
        end
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    raise HasInstances unless @project.project_instances.empty?

    @project.destroy
    flash[:notice] = 'Project was successfully deleted.'

    respond_with(@project)
  end

  private

  def find_project
    @project = Project.find(params[:id])
  end

  def available_developers
    devs = Project.pluck(:developers).flatten
    users = User.pluck(:name)
    @developers = (devs + users).compact.uniq.sort || []
  end

  def available_designers
    @designers = Project.pluck(:designers).flatten.compact || []
  end

  def available_employees
    @employees = HTTParty.get(Rails.application.secrets.employees_endpoint_url)
    @employees = [] if @employees.code != 200
  end

  def project_params
    arrays = %i[developers internal_clients external_clients project_leads other_technologies]
    project_column_names = Project.column_names.map(&:to_sym) - [:id]

    modified_names = project_column_names.map do |name|
      arrays.include?(name) ? name.to_s.concat('_array').to_sym : name
    end

    modified_names.push(
      master_sub_relationship_attributes: %i[id master_project_id _destroy],
      sub_master_relationship_attributes: %i[id sub_project_id _destroy]
    )

    params.require(:project).permit(modified_names)
  end

  def rescue_has_instances_exception
    redirect_back fallback_location: projects_url, alert: 'This project has project instances. Delete its project instances first'
  end

  def html_list
    @projects = Project.includes(:project_instances, :reviews).order(:title, 'reviews.updated_at')
    gon.push({
               states: Project.pluck_field(:state),
               rails_versions: Project.pluck_field(:rails_version),
               ruby_versions: Project.pluck_field(:ruby_version),
               postgresql_versions: Project.pluck_field(:postgresql_version)
             })
  end

  def csv_list
    project_export = if params[:scope] == 'combined'
                       CombinedProjectsExport.new
                     else
                       ProjectsExport.new
                     end
    send_file(project_export.export, type: 'text/csv')
  end

  def project_status_options
    # Populates the state dropdown in the form
    Project::STATES.map { |state| [state, state] }
  end
end
