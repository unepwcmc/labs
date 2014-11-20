class ProjectsController < ApplicationController
  before_action :authenticate_user!, :except => [:index]
  before_action :available_developers, :only => [:new, :edit]
  before_action :available_employees, :only => [:new, :edit]
  # GET /projects
  # GET /projects.json
  def index

    @projects = params[:search].present? ?
        Project.search(params[:search]).order("created_at DESC") :
        Project.order("created_at DESC")

    @projects = @projects.published unless user_signed_in?

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @projects }
    end
  end

  def list
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
    @installations = @project.installations

    @comments = @project.comments.order(:created_at)
    @comment = Comment.new

    @master_projects = @project.master_projects.select("title, projects.id")
    @sub_projects = @project.sub_projects.select("title, projects.id")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, :notice => 'Project was successfully created.' }
        format.json { render :json => @project, :status => :created, :location => @project }
      else
        format.html {
          available_developers
          available_employees
          render :action => "new"
        }
        format.json { render :json => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(project_params)
        format.html { redirect_to @project, :notice => 'Project was successfully updated.' }
        format.json { head :ok }
      else
        format.html {
          available_developers
          available_employees
          render :action => "edit"
        }
        format.json { render :json => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :ok }
    end
  end

  private

  def available_developers
    devs = Project.select("unnest(developers) as developers").where('developers IS NOT NULL').uniq.
      map(&:developers)
    users = User.select(:name).map(&:name)
    @developers = (devs + users).uniq.reject{|t| t.nil?}.sort || []
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
      :dropbox_folders_array, :pivotal_tracker_ids_array, :trello_ids_array, :backup_information, :expected_release_date,
      :rails_version, :ruby_version, :postgresql_version, :other_technologies_array, :published, :internal_description)
  end
end
