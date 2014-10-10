# == Schema Information
#
# Table name: projects
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  description      :text
#  url              :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  published        :boolean          default(FALSE)
#  screenshot       :string(255)
#  repository_url   :string(255)
#  dependencies     :text
#  state            :string(255)
#  internal_client  :string(255)
#  current_lead     :string(255)
#  hacks            :text
#  external_clients :string(255)
#  project_leads    :string(255)
#  developers       :string(255)
#  pdrive_folders   :string(255)
#  dropbox_folders  :string(255)
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
	should validate_presence_of :title
	should validate_presence_of :description
	should validate_presence_of :repository_url
	should validate_presence_of :state
	should validate_inclusion_of(:state).in_array(['Under Development', 'Delivered', 'Project Development'])
	should validate_presence_of :internal_client
	should validate_presence_of :current_lead
	should validate_presence_of :external_clients
	should validate_presence_of :project_leads
	should validate_presence_of :developers

	test "responds to metaprogrammed array methods" do
		@project = FactoryGirl.build(:project)
		assert @project.respond_to?(:developers)
		assert @project.respond_to?(:external_clients)
		assert @project.respond_to?(:project_leads)
		assert @project.respond_to?(:pdrive_folders)
		assert @project.respond_to?(:dropbox_folders)
	end
end
