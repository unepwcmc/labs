class ServersController < ApplicationController
  before_action :authenticate_user!

  respond_to :html, :json

  def index
    @servers = Server.all
  end

  def show
    @server = Server.with_deleted.find(params[:id])
    @installations = @server.installations
    @comments = @server.comments.order(:created_at)
    @comment = Comment.new
  end

  def new
    @server = Server.new
  end

  def edit
    @server = Server.with_deleted.find(params[:id])
  end

  def create
    @server = Server.new(server_params)

    flash[:notice] = 'Server was successfully created' if @server.save
    respond_with(@server)
  end

  def update
    @server = Server.with_deleted.find(params[:id])

    flash[:notice] = 'Server was successfully updated.' if @server.update_attributes(server_params)
    respond_with(@server)
  end

  def destroy
    @server = Server.with_deleted.find(params[:id])
    @server.really_destroy!
    flash[:notice] = 'Server was successfully deleted'

    respond_with(@server)
  end

  def soft_delete
    @server = Server.with_deleted.find(params[:id])

    deleted = @server.deleted?
    message = "*#{@server.name}* server has been #{deleted ? 'restarted' : 'shut down'} with the following comment: " +
      "```#{params[:comment][:content]}```"

    if deleted
      params[:comment][:content][/\A/] = '<i style="color: green;"> RESTARTED </i><br>'
      SlackChannel.post("#labs", "Labs detective", message, ":squirrel:")
      @server.restore(recursive: true)
    else
      params[:comment][:content][/\A/] = '<i style="color: red;"> SHUT DOWN </i><br>'
      SlackChannel.post("#labs", "Labs detective", message, ":squirrel:")
      @server.destroy
    end

    @server.comments.create(comment_params)
    @installations = @server.installations.with_deleted

    @installations.each do |installation|
      installation.comments.create(comment_params)
    end

    redirect_to servers_url
  end

  def deleted_list
    @servers = Server.only_deleted
  end

  private

    def server_params
      params.require(:server).permit(:name, :domain, :username, :admin_url, :os, :description, :ssh_key_name)
    end

    def comment_params
      params[:comment].permit(:content, :user_id)
    end
end
