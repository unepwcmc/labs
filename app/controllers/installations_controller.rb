class InstallationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @installations = Installation.all
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

  private
    def set_installation
      @installation = Installation.find(params[:id])
    end

    def installation_params
      params.require(:installation).permit(:project_id, :server_id, :role, :stage, :branch, :url, :description)
    end
end
