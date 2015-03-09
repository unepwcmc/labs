class ServersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @servers = Server.all
  end

  def show
    @server = Server.find(params[:id])
    @installations = @server.installations
    @comments = @server.comments.order(:created_at)
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

    if @server.save
      redirect_to @server, notice: 'Server was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @server = Server.find(params[:id])

    if @server.update_attributes(server_params)
      redirect_to @server, notice: 'Server was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @server = Server.find(params[:id])
    @server.destroy

    redirect_to servers_url
  end

  private
    def set_server
      @server = Server.find(params[:id])
    end

    def server_params
      params.require(:server).permit(:name, :domain, :username, :admin_url, :os, :description, :ssh_key_name)
    end
end
