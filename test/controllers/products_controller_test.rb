require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @product = FactoryGirl.build(:product)
    @saved_product = FactoryGirl.create(:product)
    @user = FactoryGirl.create(:user, name: 'Frodo')

    @product_a = FactoryGirl.create(:product, title: "Abacus", description: "cod", published: false, developers: ['Gandalf', @user.name])
    @product_b = FactoryGirl.create(:product, title: "Beef", description: "cod", developers: ['Aragorn', 'Elbereth'])
    @product_c = FactoryGirl.create(:product, title: "Car", description: "haddock", developers: [@user.name, 'Aragorn'])

    @product_with_instances = FactoryGirl.create(:product_with_instances)
    @product_with_dependencies = FactoryGirl.create(:product_with_dependencies)

    stub_request(:get, Rails.application.secrets.employees_endpoint_url).
    to_return(:status => 200, :body => {"employees" => ['Test','Test']}.to_json,
      :headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby', :content_type => "application/json"})
  end

  test "should get lists in html" do
    sign_in @user
    get :list, params: { format: :html }
    assert_response :success
    assert_equal assigns(:products), Product.includes(:product_instances, :reviews).order(:title, 'reviews.updated_at')
  end

  test "should get lists in csv" do
    sign_in @user
    get :list, params: { format: :csv }
    assert_response :success
    assert_equal "text/csv", response.content_type
    assert_match /attachment; filename=\"products.+\.csv\"/, response.headers["Content-Disposition"]
  end

  test "should get combined list in csv" do
    sign_in @user
    get :list, params: { scope: 'combined', format: :csv }
    assert_response :success
    assert_equal "text/csv", response.content_type
    assert_match /attachment; filename=\"combined_products.+\.csv\"/, response.headers["Content-Disposition"]
  end

  test "should return matching public products on public search" do
    get :index, params: { search: "cod" }
    assert_includes assigns(:products), @product_b
    assert_not_includes assigns(:products), @product_a
  end

  test "should return all matching products on logged in search" do
    sign_in @user
    get :index, params: { search: "cod" }
    assert_includes assigns(:products), @product_a
    assert_includes assigns(:products), @product_b
    assert_not_includes assigns(:products), @product_c
  end

  test "should return all products on logged in search with no term" do
    sign_in @user
    get :index, params: { search: "" }
    assert_equal assigns(:products), Product.order('created_at DESC')
  end

  test "should return user's product when in my_products dashboard" do
    sign_in @user
    get :index, params: {user: @user}

    assert_equal 2, assigns(:products).count
  end

  test "should return all public products on public search with no term" do
    get :index, params: { search: "" }
    assert_equal assigns(:products), Product.where(published: true).order('created_at DESC')
    assert_not_includes assigns(:products), @product_a
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "should create product" do
    sign_in @user
    assert_difference('Product.count') do
    post :create, params: { product: {  title: @product.title,
                              url: @product.url,
                              description: @product.description,
                              github_identifier: @product.github_identifier,
                              state: @product.state,
                              internal_clients_array: @product.internal_clients.join(','),
                              current_lead: @product.current_lead,
                              external_clients_array: @product.external_clients.join(','),
                              product_leads_array: @product.product_leads.join(','),
                              developers_array: @product.developers.join(','),
                              pivotal_tracker_ids: @product.pivotal_tracker_ids.join(','),
                              trello_ids: @product.trello_ids.join(','),
                              expected_release_date: @product.expected_release_date,
                              rails_version: @product.rails_version,
                              ruby_version: @product.ruby_version,
                              postgresql_version: @product.postgresql_version,
                              other_technologies: @product.other_technologies.join(','),
                              background_jobs: @product.background_jobs,
                              cron_jobs: @product.cron_jobs,
                              published: @product.published,
                              master_sub_relationship_attributes: [{
                                master_product_id: @product_with_instances.id
                              }],
                              sub_master_relationshio_attributes: [{
                                sub_product_id: @saved_product.id
                              }]
                            }
                  }
    end
    assert_redirected_to product_path(assigns(:product))
  end

  test "should render new page when failing to create product" do
    sign_in @user
    post :create, params: { product: { url: @product.url } }
    assert_template :new
  end

  test "should show product" do
    sign_in @user
    get :show, params: { id: @saved_product }
    assert_response :success
  end

  test "should get edit" do
    sign_in @user
    get :edit, params: { id: @saved_product }
    assert_response :success
  end

  test "should update product" do
    sign_in @user
    patch :update, params: { id: @saved_product, product: { title: "New Title" } }
    assert_redirected_to product_path(assigns(:product))
  end

  test "should render edit page when failing to update product" do
    sign_in @user
    patch :update, params: { id: @saved_product, product: { title: "" } }
    assert_template :edit
  end

  test "should destroy product" do
    sign_in @user
    assert_difference('Product.count', -1) do
      delete :destroy, params: { id: @saved_product }
    end
    assert_redirected_to products_path
  end

  test "should raise exception if deleting product with product instances" do
    sign_in @user
    delete :destroy, params: { id: @product_with_instances.id }

    assert_redirected_to products_path
    assert_equal "This product has product instances. Delete its product instances first", flash[:alert]
  end

  test "should add dependencies" do
    sign_in @user
    master_product = FactoryGirl.create(:product)
    sub_product = FactoryGirl.create(:product)
    assert_difference("Dependency.count", 2) do
      patch :update, params: { id: @saved_product, product:
        {
          master_sub_relationship_attributes: [
            {
              master_product_id: master_product.id
            }
          ],
          sub_master_relationship_attributes: [
            {
              sub_product_id: sub_product.id
            }
          ]
        }
      }
    end

    assert_equal 1, assigns(:product).master_products.count
    assert_equal 1, assigns(:product).sub_products.count
  end

  test "should remove dependencies" do
    sign_in @user
    dependency = Dependency.where(sub_product_id: @product_with_dependencies.id).first
    assert_difference("Dependency.count", -1) do
      patch :update, params: { id: @product_with_dependencies, product:
        {
          master_sub_relationship_attributes: [
            {
              id: dependency.id,
              _destroy: 1
            }
          ]
        }
      }
    end
    assert_equal 0, @product_with_dependencies.master_products.count
  end

end
