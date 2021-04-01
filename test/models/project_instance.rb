# frozen_string_literal: true

require 'test_helper'

class ProjectInstanceTest < ActiveSupport::TestCase
  should validate_presence_of :project_id
  should validate_presence_of :url

  test 'with a valid url' do
    @project = FactoryGirl.build(:project_instance, url: 'http://www.google.com')
    assert_not @project.valid?
  end

  test 'with an invalid url' do
    @project = FactoryGirl.build(:project_instance, url: '1234')
    assert_not @project.valid?
  end

  test 'should initialize project_instance with production as default stage' do
    attrs = FactoryGirl.attributes_for(:project_instance).except(:stage)
    @project_instance = ProjectInstance.build(attrs)
    assert_equal 'Production', @project_instance.stage
  end

  test 'should create project_instance with production as default stage' do
    attrs = FactoryGirl.attributes_for(:project_instance).except(:stage)
    @project_instance = ProjectInstance.create(attrs)
    assert_equal 'Production', @project_instance.stage
  end
end
