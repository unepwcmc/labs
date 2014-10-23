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
#  external_clients :text             default([]), is an Array
#  project_leads    :text             default([]), is an Array
#  developers       :text             default([]), is an Array
#  pdrive_folders   :text             default([]), is an Array
#  dropbox_folders  :text             default([]), is an Array
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
	should validate_presence_of :title
	should validate_presence_of :state
	should validate_inclusion_of(:state).in_array(['Under Development', 'Delivered', 'Project Development'])

	test "responds to metaprogrammed array methods" do
		@project = FactoryGirl.build(:project)
		assert @project.respond_to?(:developers)
		assert @project.respond_to?(:external_clients)
		assert @project.respond_to?(:project_leads)
		assert @project.respond_to?(:pdrive_folders)
		assert @project.respond_to?(:dropbox_folders)
	end
end
