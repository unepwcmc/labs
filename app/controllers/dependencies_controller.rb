class DependenciesController < ApplicationController

  def index
    @dependencies = Dependency.all

    respond_to do |format|
      format.html
      format.json { render :json => @dependencies }
    end
  end

  def show
    @dependency = Dependency.find(params[:id])
    @projects = [@dependency.master_project, @dependency.sub_project]

    @comments = @dependency.comments.order(:created_at)
    @comment = Comment.new

    respond_to do |format|
      format.html
      format.json { render :json => @dependency }
    end
  end

  def edit
    @dependency = Dependency.find(params[:id])
  end

  def update
    @dependency = Dependency.find(params[:id])

    respond_to do |format|
      if @dependency.update_attributes(dependency_params)
        format.html { redirect_to @dependency, :notice => 'Dependency was successfully updated.' }
        format.json { head :ok }
      else
        format.html {
          render :action => "edit"
        }
        format.json { render :json => @dependency.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new
    @dependency = Dependency.new

    respond_to do |format|
      format.html
      format.json { render :json => @dependency }
    end
  end

  def create
    @dependency = Dependency.new(dependency_params)

    respond_to do |format|
      if @dependency.save
        format.html { redirect_to @dependency, :notice => 'Dependency was successfully created.' }
        format.json { render :json => @dependency, :status => :created, :location => @dependency }
      else
        format.html {
          render :action => "new"
        }
        format.json { render :json => @dependency.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @dependency = Dependency.find(params[:id])
    @dependency.destroy

    respond_to do |format|
      format.html { redirect_to dependencies_url }
      format.json { head :ok }
    end
  end

  private

  def dependency_params
    params.require(:dependency).permit(:master_project_id, :sub_project_id)
  end
end