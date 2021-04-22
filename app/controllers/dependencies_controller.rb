class DependenciesController < ApplicationController

  respond_to :html, :json

  def index
    @dependencies = Dependency.all
  end

  def show
    @dependency = Dependency.find(params[:id])
    @products = [@dependency.master_product, @dependency.sub_product]

    @comments = @dependency.comments.order(:created_at)
    @comment = Comment.new
  end

  def edit
    @dependency = Dependency.find(params[:id])
  end

  def update
    @dependency = Dependency.find(params[:id])

    flash[:notice] = 'Dependency was successfully updated.' if @dependency.update_attributes(dependency_params)
    respond_with(@dependency)
  end

  def new
    @dependency = Dependency.new
  end

  def create
    @dependency = Dependency.new(dependency_params)

    flash[:notice] = 'Dependency was successfully created.' if @dependency.save
    respond_with(@dependency)
  end

  def destroy
    @dependency = Dependency.find(params[:id])
    @dependency.destroy
    flash[:notice] = 'Dependency was successfully deleted.'

    redirect_to dependencies_url
  end

  private

  def dependency_params
    params.require(:dependency).permit(:master_product_id, :sub_product_id)
  end
end