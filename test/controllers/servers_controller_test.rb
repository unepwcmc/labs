# frozen_string_literal: true

require 'test_helper'

class ServersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @server = FactoryGirl.create(:server)
    @new_server = FactoryGirl.build(:server)
    @server_with_installations = FactoryGirl.create(:server_with_installations)
    @soft_deleted_server_with_installations = FactoryGirl.create(:soft_deleted_server_with_installations)
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:servers)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create server' do
    assert_difference('Server.count') do
      post :create, params: { server: { admin_url: @new_server.admin_url,
                                        description: @new_server.description,
                                        domain: @new_server.domain,
                                        name: @new_server.name,
                                        os: @new_server.os,
                                        username: @new_server.username,
                                        ssh_key_name: @new_server.ssh_key_name,
                                        open_ports: @new_server.open_ports } }
    end
    assert_redirected_to server_path(assigns(:server))
  end

  test 'should show server' do
    get :show, params: { id: @server }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @server }
    assert_response :success
  end

  test 'should update server' do
    patch :update, params: {
      id: @server,
      server: {
        admin_url: @server.admin_url,
        description: @server.description,
        domain: @server.domain,
        name: @server.name,
        os: @server.os,
        username: @server.username
      }
    }
    assert_redirected_to server_path(assigns(:server))
  end

  test 'should destroy server' do
    assert_difference('Server.count', -1) do
      delete :destroy, params: { id: @server }
    end

    assert_redirected_to servers_path
  end

  test 'should get deleted list' do
    get :deleted_list
    assert_response :success
    assert_not_nil assigns(:servers)
  end

  test 'should soft-delete server and associated installations' do
    stub_slack_comment do
      assert_differences([['Server.count', -1], ['Installation.count', -3]]) do
        patch :soft_delete, params: { id: @server_with_installations, comment:
          {
            content: 'Shut down message',
            user_id: @user.id
          } }
      end

      assert_equal 2, Server.only_deleted.count
      assert_equal 5, Installation.only_deleted.count

      assert_equal 1, @server_with_installations.comments.count

      @server_with_installations.installations.each do |installation|
        assert_equal 1, installation.comments.count
      end
    end
  end

  test 'should restore soft-deleted server and associated installations' do
    stub_slack_comment do
      assert_differences([['Server.count', 1], ['Installation.count', 2]]) do
        patch :soft_delete, params: { id: @soft_deleted_server_with_installations, comment:
          {
            content: 'Restore message',
            user_id: @user.id
          } }
      end

      assert_equal 0, Server.only_deleted.count
      assert_equal 0, Installation.only_deleted.count
    end
  end

  test 'should send a notification when closing server' do
    message = "*#{@server.name}* server has been scheduled for close down"
    SlackChannel.expects(:post).with('#labs', 'Labs detective (test)', message, ':squirrel:')
    patch :update, params: { id: @server, server: {
      closing: true
    } }
    assert_redirected_to server_path(assigns(:server))
  end

  test 'should send a notification when re-opening server' do
    server = FactoryGirl.create(:server, { closing: true })
    message = "*#{server.name}* server has been unscheduled for close down"
    SlackChannel.expects(:post).with('#labs', 'Labs detective (test)', message, ':squirrel:')
    patch :update, params: { id: server, server: {
      closing: false
    } }
    assert_redirected_to server_path(assigns(:server))
  end
end
