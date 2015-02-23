require 'test_helper'

class ProjectInstanceTest < ActiveSupport::TestCase
  should validate_presence_of :project_id
  should validate_presence_of :url

  test "with a valid url" do
    @project = FactoryGirl.build(:project_instance, url: "http://www.google.com")
    assert_not @project.valid?
  end

  test "with an invalid url" do
    @project = FactoryGirl.build(:project_instance, url: "1234")
    assert_not @project.valid?
  end
end