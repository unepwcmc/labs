require 'test_helper'

class ServersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @server = FactoryGirl.create(:server)
    @new_server = FactoryGirl.build(:server)
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create server" do
    assert_difference('Server.count') do
      post :create, server: { admin_url: @new_server.admin_url, description: @new_server.description, domain: @new_server.domain, name: @new_server.name, os: @new_server.os, username: @new_server.username }
    end
    assert_redirected_to server_path(assigns(:server))
  end

  test "should show server" do
    get :show, id: @server
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @server
    assert_response :success
  end

  test "should update server" do
    patch :update, id: @server, server: { admin_url: @server.admin_url, description: @server.description, domain: @server.domain, name: @server.name, os: @server.os, username: @server.username }
    assert_redirected_to server_path(assigns(:server))
  end

  test "should destroy server" do
    assert_difference('Server.count', -1) do
      delete :destroy, id: @server
    end

    assert_redirected_to servers_path
  end
end
