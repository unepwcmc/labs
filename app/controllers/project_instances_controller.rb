class ProjectInstancesController < ApplicationController

  def index
    @projects_instances = ProjectInstance.all

    respond_to do |format|
      format.html {
        gon.push({
          :stages => @projects_instances.pluck(:stage).uniq
        })
        render 'index'
      }
      format.json { render :json => @projects_instances }
      format.csv {
        send_file(Pathname.new(ProjectInstancesExport.new.export).realpath, type: 'text/csv')
      }
    end
  end

  def show
    @project_instance = ProjectInstance.with_deleted.find(params[:id])

    @comments = @project_instance.comments.order(:created_at)
    @comment = Comment.new

    respond_to do |format|
      format.html
      format.json { render :json => @project_instance }
    end
  end

  def edit
    @project_instance = ProjectInstance.with_deleted.find(params[:id])
    comment = @project_instance.comments.build
  end

  def update
    @project_instance = ProjectInstance.with_deleted.find(params[:id])
    @installations = @project_instance.installations
    closing_flag = @project_instance.closing

    respond_to do |format|
      if @project_instance.update_attributes(project_instance_params)

        if @project_instance.closing != closing_flag
          @installations.each do |installation|
            installation.update_attributes(closing: project_instance_params[:closing])
          end
        end

        format.html { redirect_to @project_instance,
          :notice => "Instance was successfully updated." }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @project_instance.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new
    project_id = Project.where("url like ?", "%#{params[:nagios_url]}%").first.try(:id) if params[:nagios_url]

    @project_instance = ProjectInstance.new(project_id: project_id, url: params[:nagios_url])

    respond_to do |format|
      format.html
      format.json { render :json => @project_instance }
    end
  end

  def create
    @project_instance = ProjectInstance.new(project_instance_params)

    respond_to do |format|
      if @project_instance.save
        format.html { redirect_to @project_instance,
          :notice => "Instance was successfully created." }
        format.json { render :json => @project_instance, :status => :created,
          :location => @project_instance }
      else
        format.html { render :action => "new" }
        format.json { render :json => @project_instance.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_instance = ProjectInstance.with_deleted.find(params[:id])
    @project_instance.really_destroy!

    respond_to do |format|
      format.html { redirect_to project_instances_url }
      format.json { head :ok }
    end
  end

  def soft_delete
    @project_instance = ProjectInstance.with_deleted.find(params[:id])

    if @project_instance.deleted?
      params[:comment][:content][/\A/] =
        '<i style="color: green;"> REACTIVATED </i></br>'

      @project_instance.restore(recursive: true)
    else
      params[:comment][:content][/\A/] =
        '<i style="color: red;"> SHUT DOWN </i></br>'

      @project_instance.destroy
    end

    @project_instance.comments.create(comment_params)
    @installations = @project_instance.installations.with_deleted

    @installations.each do |installation|
      installation.comments.create(comment_params)
    end

    respond_to do |format|
      format.html { redirect_to project_instances_url }
    end
  end

  def deleted_list
    @projects_instances = ProjectInstance.only_deleted

    respond_to do |format|
      format.html
      format.json { render :json => { data: @projects_instances }.to_json }
    end
  end

  def nagios_list
    @sites = Github.get_nagios_sites
  end

  private

  def project_instance_params
    params.require(:project_instance).permit(:project_id, :name, :url, :backup_information,
      :stage, :branch, :description, :closing, :closed, comment: [:id, :content, :user_id], installation_ids: [])
  end

  def comment_params
    params[:comment].permit(:content, :user_id)
  end

end