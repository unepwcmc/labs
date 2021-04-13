class ProductInstancesController < ApplicationController

  respond_to :html, :json

  def index
    @products_instances = ProductInstance.includes(:product, :installations)

    respond_with(@product_instance) do |format|
      format.html {
        gon.push({
          :stages => @products_instances.pluck(:stage).uniq
        })
        render 'index'
      }
      format.csv {
        send_file(ProductInstancesExport.new.export, type: 'text/csv')
      }
    end
  end

  def show
    @product_instance = ProductInstance.with_deleted.find(params[:id])

    @comments = @product_instance.comments.order(:created_at)
    @comment = Comment.new

    respond_with(@product_instance)
  end

  def edit
    @product_instance = ProductInstance.with_deleted.find(params[:id])
    comment = @product_instance.comments.build
  end

  def update
    @product_instance = ProductInstance.with_deleted.find(params[:id])
    @installations = @product_instance.installations

    SlackChannel.closing_notification(@product_instance, product_instance_params) do
      @installations.each do |installation|
        installation.update_attributes(closing: product_instance_params[:closing])
      end
      flash[:notice] = "Instance was successfully updated."
    end

    respond_with(@product_instance)
  end

  def new
    nagios_url = params[:nagios_url]

    if nagios_url.present?
      product_id = Product.where("url like ?", "%#{params[:nagios_url]}%").first.try(:id)
      nagios_url[/\A/] = 'http://' unless /\Ahttp(s)?:\/\//.match(nagios_url)
    end

    @product_instance = ProductInstance.new(product_id: product_id, url: nagios_url)
  end

  def create
    @product_instance = ProductInstance.new(product_instance_params)
    @product_instance.populate_name

    flash[:notice] = "Instance was successfully created." if @product_instance.save
    respond_with(@product_instance)
  end

  def destroy
    @product_instance = ProductInstance.with_deleted.find(params[:id])
    @product_instance.really_destroy!
    flash[:notice] = 'Instance was successfully deleted.'

    respond_with(@product_instance)
  end

  def soft_delete
    @product_instance = ProductInstance.with_deleted.find(params[:id])

    deleted = @product_instance.deleted?
    message = "*#{@product_instance.name}* product instance has been #{deleted ? 'restarted' : 'shut down'} with the following comment: " +
      "```#{params[:comment][:content]}```"

    if deleted
      params[:comment][:content][/\A/] = '<i style="color: green;"> RESTARTED </i><br>'
      SlackChannel.post("#labs", "Labs detective", message, ":squirrel:")
      @product_instance.restore(recursive: true)
    else
      params[:comment][:content][/\A/] = '<i style="color: red;"> SHUT DOWN </i><br>'
      SlackChannel.post("#labs", "Labs detective", message, ":squirrel:")
      @product_instance.destroy
    end

    @product_instance.comments.create(comment_params)
    @installations = @product_instance.installations.with_deleted

    @installations.each do |installation|
      installation.comments.create(comment_params)
    end

    redirect_to product_instances_url
  end

  def deleted_list
    @products_instances = ProductInstance.only_deleted
  end

  def nagios_list
    @sites = Nagios.get_sites
    @sites.delete_if{ |site| ProductInstance.where("url like ?", "%#{site}%").present? }
  end

  private

  def product_instance_params
    params.require(:product_instance).permit(:product_id, :name, :url, :backup_information,
      :stage, :branch, :description, :closing, :closed,
      installations_attributes: [:id, :server_id, :role, :description, :_destroy], comment: [:id, :content, :user_id])
  end

  def comment_params
    params[:comment].permit(:content, :user_id)
  end

end
