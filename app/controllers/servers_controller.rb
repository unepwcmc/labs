class ServersController < ApplicationController
  before_action :authenticate_user!

  respond_to :html, :json

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

    flash[:notice] = 'Server was successfully created' if @server.save
    respond_with(@server)
  end

  def update
    @server = Server.find(params[:id])

    flash[:notice] = 'Server was successfully updated.' if @server.update_attributes(server_params)
    respond_with(@server)
  end

  def destroy
    @server = Server.find(params[:id])
    @server.destroy
    flash[:notice] = 'Server was successfully deleted'

    respond_with(@server)
  end

  private

    def server_params
      params.require(:server).permit(:name, :domain, :username, :admin_url, :os, :description, :ssh_key_name)
    end
end
