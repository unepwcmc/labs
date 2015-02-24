class InstallationsController < ApplicationController
  before_action :authenticate_user!

  def index

    gon.push({
      :roles => Installation.pluck(:role).uniq
    })

    respond_to do |format|
      format.html {
        @installations = Installation.all
        render 'index'
      }
      format.csv {
        send_file(Pathname.new(InstallationsExport.new.export).realpath, type: 'text/csv')
      }
    end
  end

  def show
    set_installation

    @comments = @installation.comments.order(:created_at)
    @comment = Comment.new

  end

  def new
    @installation = Installation.new
  end

  def edit
    set_installation
  end

  def create
    @installation = Installation.new(installation_params)


    respond_to do |format|
      if @installation.save
        format.html { redirect_to installations_path, :notice => 'Installation was successfully created.' }
        format.json { render :json => @installation, :status => :created, :location => @installation }
      else
        format.html { render :action => "new" }
        format.json { render :json => @installation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    set_installation

    respond_to do |format|
      if @installation.update_attributes(installation_params)
        format.html { redirect_to @installation, :notice => 'Installation was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @installation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    set_installation
    @installation.destroy

    respond_to do |format|
      format.html { redirect_to installations_url }
      format.json { head :ok }
    end
  end

  def soft_delete
    @installation = Installation.with_deleted.find(params[:id])

    if @installation.deleted?
      params[:comment][:content][/\A/] =
        '<i style="color: green;"> REACTIVATED </i></br>'

      @installation.restore
    else
      params[:comment][:content][/\A/] =
        '<i style="color: red;"> SHUT DOWN </i></br>'

      @installation.destroy
    end

    @installation.comments.create(comment_params)

    respond_to do |format|
      format.html { redirect_to installations_url }
    end
  end

  def deleted_list
    @installations = Installation.only_deleted

    gon.push({
      :roles => Installation.only_deleted.pluck(:role).uniq
    })

    respond_to do |format|
      format.html
    end
  end

  private
    def set_installation
      @installation = Installation.with_deleted.find(params[:id])
    end

    def installation_params
      params.require(:installation).permit(:project_instance_id,
        :server_id, :role, :description, :closing)
    end

    def comment_params
      params[:comment].permit(:content, :user_id)
    end
end
