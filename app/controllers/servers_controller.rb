class ServersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @servers = Server.all
  end

  def show
    @server = Server.find(params[:id])
    @installations = @server.installations

    @comments = @server.comments
    @comment = Comment.new

  end

  def new
    @server = Server.new
  end

  def edit
    @server = Server.find(params[:id])
  end

  def create
    @server = Server.new(server_params)

    respond_to do |format|
      if @server.save
        format.html { redirect_to @server, :notice => 'Server was successfully created.' }
        format.json { render :json => @server, :status => :created, :location => @server }
      else
        format.html { render :action => "new" }
        format.json { render :json => @server.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @server = Server.find(params[:id])

    respond_to do |format|
      if @server.update_attributes(server_params)
        format.html { redirect_to @server, :notice => 'Server was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @server.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @server = Server.find(params[:id])
    @server.destroy

    respond_to do |format|
      format.html { redirect_to servers_url }
      format.json { head :ok }
    end
  end

  private
    def set_server
      @server = Server.find(params[:id])
    end

    def server_params
      params.require(:server).permit(:name, :domain, :username, :admin_url, :os, :description)
    end
end
