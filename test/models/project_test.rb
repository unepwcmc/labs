# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  title                 :string(255)      not null
#  description           :text             not null
#  url                   :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  published             :boolean          default(FALSE)
#  screenshot            :string(255)
#  github_identifier     :string(255)
#  dependencies          :text
#  state                 :string(255)      not null
#  current_lead          :string(255)
#  hacks                 :text
#  external_clients      :text             default([]), is an Array
#  project_leads         :text             default([]), is an Array
#  developers            :text             default([]), is an Array
#  pdrive_folders        :text             default([]), is an Array
#  dropbox_folders       :text             default([]), is an Array
#  pivotal_tracker_ids   :text             default([]), is an Array
#  trello_ids            :text             default([]), is an Array
#  expected_release_date :date
#  rails_version         :string(255)
#  ruby_version          :string(255)
#  postgresql_version    :string(255)
#  other_technologies    :text             default([]), is an Array
#  internal_clients      :text             default([]), is an Array
#  internal_description  :text
#  background_jobs       :text
#  cron_jobs             :text
#  user_access           :text
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  should validate_presence_of :title
  should validate_presence_of :description
  should validate_presence_of :state
  should validate_inclusion_of(:state).in_array(['Under Development', 'Delivered', 'Project Development'])
 
  test "responds to metaprogrammed array methods" do
    @project = FactoryGirl.build(:project)
    assert @project.respond_to?(:developers)
    assert @project.respond_to?(:internal_clients)
    assert @project.respond_to?(:external_clients)
    assert @project.respond_to?(:project_leads)
    assert @project.respond_to?(:pdrive_folders)
    assert @project.respond_to?(:dropbox_folders)
  end
 
  context "Project NOT published" do
    should_not validate_presence_of :url
  end
 
  context "Project published" do
    subject do
      Project.new(:title => 'Valid Title', :description => 'Valid Description', :state => 'Delivered', :published => true)
    end
    should validate_presence_of(:url)
  end

  def test_team_members_auto_check
    @project1 = FactoryGirl.create(:project, current_lead: 'Dev 1')
    @project2 = FactoryGirl.create(:project, current_lead: nil)
    assert @project1.team_members?
    assert !@project2.team_members?
  end

  def test_production_instance_auto_check
    @project1 = FactoryGirl.create(:project)
    @instance1 = FactoryGirl.create(:project_instance, project: @project1, stage: 'Production')
    FactoryGirl.create(:installation, project_instance: @instance1)
    @project2 = FactoryGirl.create(:project)
    assert @project1.production_instance?
    assert !@project2.production_instance?
  end

  def test_staging_instance_auto_check
    @project1 = FactoryGirl.create(:project)
    @instance1 = FactoryGirl.create(:project_instance, project: @project1, stage: 'Staging')
    FactoryGirl.create(:installation, project_instance: @instance1)
    @project2 = FactoryGirl.create(:project)
    assert @project1.staging_instance?
    assert !@project2.staging_instance?
  end

  def test_production_backups_auto_check
    @project1 = FactoryGirl.create(:project)
    @instance1 = FactoryGirl.create(:project_instance,
      project: @project1, stage: 'Production', backup_information: 'loads of backup'
    )
    FactoryGirl.create(:installation, project_instance: @instance1)
    @project2 = FactoryGirl.create(:project)
    assert @project1.production_backups?
    assert !@project2.production_backups?
  end

end
