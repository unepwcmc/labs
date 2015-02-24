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
end
