require 'test_helper'

class ProductInstancesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @product_instance = FactoryGirl.create(:product_instance)
    @new_product_instance = FactoryGirl.build(:product_instance)
    @product_instance_with_installations = FactoryGirl.create(:product_instance_with_installations)
    @soft_deleted_product_instance_with_installations = FactoryGirl.create(:soft_deleted_product_instance_with_installations)
    @installation = FactoryGirl.build(:installation)
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test "should get index in html" do
    get :index, params: { format: :html }
    assert_response :success
    assert_not_nil assigns(:products_instances)
  end

  test "should get index in csv" do
    get :index, params: { format: :csv }
    assert_response :success
    assert_equal "text/csv", response.content_type
    assert_match /attachment; filename=\"product_instances.+\.csv\"/, response.headers["Content-Disposition"]
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_instance" do
    assert_differences([['ProductInstance.count', 1],['Installation.count', 1]]) do
      post :create, params: { product_instance: { branch: @new_product_instance.branch,
          description: @new_product_instance.description,
          product_id: @new_product_instance.product_id, name: @new_product_instance.name,
          backup_information: @new_product_instance.backup_information,
          stage: @new_product_instance.stage, url: @new_product_instance.url,
          installations_attributes: [{
            server_id: @installation.server_id,
            role: @installation.role,
            description: @installation.description
          }]
        }
      }
    end

    assert_redirected_to "/product_instances/#{ProductInstance.last.id}"
  end

  test "should generate name for product_instance if not provided" do
    assert_differences([['ProductInstance.count', 1],['Installation.count', 1]]) do
      post :create, params: { product_instance: { branch: @new_product_instance.branch,
          description: @new_product_instance.description,
          product_id: @new_product_instance.product_id, name: nil,
          backup_information: @new_product_instance.backup_information,
          stage: @new_product_instance.stage, url: @new_product_instance.url,
          installations_attributes: [{
            server_id: @installation.server_id,
            role: @installation.role,
            description: @installation.description
          }]
        }
      }
    end

    product = Product.find(@new_product_instance.product_id)
    assert_equal "#{product.title} (#{@new_product_instance.stage})", ProductInstance.last.name
  end

  test "should show product_instance" do
    get :show, params: { id: @product_instance }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @product_instance }
    assert_response :success
  end

  test "should update product_instance" do
    installation = @product_instance_with_installations.installations.first
    patch :update, params: { id: @product_instance_with_installations, product_instance:
      {
        branch: @new_product_instance.branch, description: @new_product_instance.description,
        product_id: @new_product_instance.product_id, name: @new_product_instance.name,
        backup_information: @new_product_instance.backup_information,
        stage: @new_product_instance.stage, url: @new_product_instance.url,
        installations_attributes: [{
          id: installation.id,
          server_id: @installation.server_id,
          role: @installation.role,
          description: @installation.description
        }]
      }
    }
    assert_redirected_to product_instance_path(assigns(:product_instance))
  end

  test "should destroy product_instance" do
    assert_difference('ProductInstance.count', -1) do
      delete :destroy, params: { id: @product_instance }
    end

    assert_redirected_to product_instances_path
  end

  test "should get deleted list" do
    get :deleted_list
    assert_response :success
    assert_not_nil assigns(:products_instances)
  end

  test "should send a notification when closing product_instance" do
    message = "*#{@product_instance.name}* productinstance has been scheduled for close down"
    SlackChannel.expects(:post).with("#labs", "Labs detective (test)", message, ":squirrel:")
    patch :update, params: { id: @product_instance, product_instance: {
        closing: true
      }
    }
    assert_redirected_to product_instance_path(assigns(:product_instance))
  end

  test "should send a notification when re-opening product_instance" do
    product_instance = FactoryGirl.create(:product_instance, {closing: true})
    message = "*#{product_instance.name}* productinstance has been unscheduled for close down"
    SlackChannel.expects(:post).with("#labs", "Labs detective (test)", message, ":squirrel:")
    patch :update, params: { id: product_instance, product_instance: {
        closing: false
      }
    }
    assert_redirected_to product_instance_path(assigns(:product_instance))
  end

  test "should cascade closing flag to installations" do
    stub_slack_comment do
      patch :update, params: { id: @product_instance_with_installations, product_instance:
        {
          branch: @new_product_instance.branch, description: @new_product_instance.description,
          product_id: @new_product_instance.product_id, name: @new_product_instance.name,
          backup_information: @new_product_instance.backup_information,
          stage: @new_product_instance.stage, url: @new_product_instance.url,
          closing: true
        }
      }

      @product_instance_with_installations.installations.each do |installation|
        assert_equal true, installation.closing
      end
    end
  end

  test "should soft-delete product_instance and associated installations" do
    stub_slack_comment do
      assert_differences([['ProductInstance.count', -1],['Installation.count', -3]]) do
        patch :soft_delete, params: { id: @product_instance_with_installations, comment:
          {
            content: "Shut down message",
            user_id: @user.id
          }
        }
      end

      assert_equal 2, ProductInstance.only_deleted.count
      assert_equal 5, Installation.only_deleted.count

      assert_equal 1, @product_instance_with_installations.comments.count

      @product_instance_with_installations.installations.each do |installation|
        assert_equal 1, installation.comments.count
      end
    end
  end

  test "should restore soft-deleted product_instance and associated installations" do
    stub_slack_comment do
      assert_differences([['ProductInstance.count', 1],['Installation.count', 2]]) do
        patch :soft_delete, params: { id: @soft_deleted_product_instance_with_installations, comment:
          {
            content: "Restore message",
            user_id: @user.id
          }
        }
      end

      assert_equal 0, ProductInstance.only_deleted.count
      assert_equal 0, Installation.only_deleted.count
    end
  end

  test "should get nagios list" do
    stub_request(:get, Rails.application.secrets.nagios_list_url).
      to_return(:status => 200, :body => "name\tvalue\napi.speciesplus.net\t100.000\nbern-ors.unep-wcmc.org\t100.000", :headers => {})
    get :nagios_list
    assert_not_nil assigns(:sites)
    assert_response :success
  end

  test "should populate new product_instance" do
    url = "http://www.google.com"
    FactoryGirl.create(:product, url: url)
    get :new, params: { nagios_url: url }
    assert_equal Product.last.id, assigns(:product_instance).product_id
    assert_equal url, assigns(:product_instance).url
  end

  test "should add installations" do
    another_installation = FactoryGirl.build(:installation)
    assert_difference("Installation.count", 2) do
      patch :update, params: { id: @product_instance, product_instance:
        {
          installations_attributes: [
            {
              server_id: @installation.server_id,
              role: @installation.role,
              description: @installation.description
            },
            {
              server_id: another_installation.server_id,
              role: another_installation.role,
              description: another_installation.description
            }
          ]
        }
      }
    end
    assert_equal 2, @product_instance.installations.count
  end

  test "should remove installations" do
    installation = @product_instance_with_installations.installations.first
    assert_differences([["Installation.count", -1],["Installation.only_deleted.count", 1]]) do
      patch :update, params: { id: @product_instance_with_installations, product_instance:
        {
          installations_attributes: [
            {
              id: installation.id,
              _destroy: 1
            }
          ]
        }
      }
    end
    assert_equal 2, @product_instance_with_installations.installations.count
  end

end
