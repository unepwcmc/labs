# frozen_string_literal: true

class ProductsController < ApplicationController
  include Errors
  before_action :authenticate_user!, :except => [:index]
  before_action :available_developers, :only => %i[new edit]
  before_action :available_designers, :only => %i[new edit]
  before_action :available_employees, :only => %i[new edit]
  before_action :find_product, only: %i[show edit update destroy]
  # GET /products
  # GET /products.json

  rescue_from HasInstances, with: :rescue_has_instances_exception

  respond_to :html, :json

  def index
    if user_signed_in? && params[:user]
      username = User.find(params[:user]).name
      @products = Product.where("developers @> '{#{username}}'::text[] OR current_lead = '#{username}'")
    else
      @products = params[:search].present? ?
          Product.search(params[:search]).order('created_at DESC') :
          Product.order('created_at DESC')

      @products = @products.published unless user_signed_in?
    end

    respond_with(@products)
  end

  def list
    respond_to do |format|
      format.html { html_list }
      format.csv { csv_list }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    deprecated_resources = %i(pdrive_folders dropbox_folders pivotal_tracker_ids trello_ids)
    @no_deprecated_resources = deprecated_resources.all? do |res|
      @product.send(res).blank?
    end

    @instances = @product.product_instances

    @comments = @product.comments.order(:created_at)
    @comment = Comment.new

    @master_products = @product.master_products.select('title, products.id')
    @sub_products = @product.sub_products.select('title, products.id')

    respond_with(@product)
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new
    @product_status_options = product_status_options
    @product_leading_style_options = product_leading_style_options

    respond_with(@product)
  end

  # GET /products/1/edit
  def edit
    @product_status_options = product_status_options
    @product_leading_style_options = product_leading_style_options
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_with(@product) do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
      else
        format.html do
          available_developers
          available_designers
          available_employees
          render action: 'new'
        end
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product_status_options = product_status_options
    @product_leading_style_options = product_leading_style_options

    respond_with(@product) do |format|
      if @product.update_attributes(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
      else
        format.html do
          available_developers
          available_designers
          available_employees
          render action: 'edit'
        end
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    raise HasInstances unless @product.product_instances.empty?

    @product.destroy
    flash[:notice] = 'Product was successfully deleted.'

    respond_with(@product)
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end

  def available_developers
    devs = Product.pluck(:developers).flatten
    users = User.pluck(:name)
    @developers = (devs + users).compact.uniq.sort || []
  end

  def available_designers
    @designers = Product.pluck(:designers).flatten.compact || []
  end

  def available_employees
    @employees = HTTParty.get(Rails.application.secrets.employees_endpoint_url)
    @employees = [] if @employees.code != 200
  end

  def product_params
    arrays = %i[developers designers internal_clients external_clients product_leads other_technologies]
    product_column_names = Product.column_names.map(&:to_sym) - [:id]

    modified_names = product_column_names.map do |name|
      arrays.include?(name) ? name.to_s.concat('_array').to_sym : name
    end

    modified_names.push(
      master_sub_relationship_attributes: %i[id master_product_id _destroy],
      sub_master_relationship_attributes: %i[id sub_product_id _destroy]
    )

    params.require(:product).permit(modified_names)
  end

  def rescue_has_instances_exception
    redirect_back fallback_location: products_url, alert: 'This product has product instances. Delete its product instances first'
  end

  def html_list
    @products = Product.includes(:product_instances, :reviews).order(:title, 'reviews.updated_at')
    gon.push({
               states: Product.pluck_field(:state),
               rails_versions: Product.pluck_field(:rails_version),
               ruby_versions: Product.pluck_field(:ruby_version),
               postgresql_versions: Product.pluck_field(:postgresql_version)
             })
  end

  def csv_list
    product_export = if params[:scope] == 'combined'
                       CombinedProductsExport.new
                     else
                       ProductsExport.new
                     end
    send_file(product_export.export, type: 'text/csv')
  end

  def product_status_options
    # Populates the state dropdown in the form
    Product::STATES.map { |state| [state, state] }
  end

  def product_leading_style_options
    Product::LEADS.map { |lead| [lead, lead] }
  end
end
