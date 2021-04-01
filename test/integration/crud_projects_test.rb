# frozen_string_literal: true

require 'test_helper'

class CrudProjectsTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryGirl.build(:user)
    @project = FactoryGirl.create(:project)
    @draft_project = FactoryGirl.create(:draft_project)

    stub_request(:get, Rails.application.secrets.employees_endpoint_url)
      .to_return(status: 200, body: { 'employees' => %w[Test Test] }.to_json,
      headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby', :content_type => 'application/json' })
  end

  test 'index page shows public projects to public user' do
    visit root_path
    page.has_content? @project.title
    page.has_no_text? @draft_project.title
  end

  test 'index page shows all projects to logged in user' do
    sign_in_with_github @user, true
    visit root_path
    page.has_content? @project.title
    page.has_content? @draft_project.title
  end

  test 'creating a new project adds it to the database' do
    sign_in_with_github @user, true
    visit root_path
    assert_difference 'Project.count', +1 do
      click_button 'Add a new Project'
      @new_project = FactoryGirl.build(:project)
      within('#new_project') do
        fill_in 'Title', with: @project.title
        fill_in 'Description', with: @project.description
        fill_in 'Url', with: @project.url
        fill_in 'Github identifier', with: @project.github_identifier
        select @project.state, from: 'State'
        fill_in 'project_internal_clients_array', with: @project.internal_clients.join("\n")
        fill_in 'Current lead', with: @project.current_lead
        fill_in 'project_external_clients_array', with: @project.external_clients.join("\n")
        fill_in 'project_project_leads_array', with: @project.project_leads.join("\n")
        fill_in 'project_developers_array', with: @project.developers.join("\n")
        check 'Published'
      end
      click_button 'Create Project'
    end
  end

  test 'projects have edit, show, and destroy options when logged in' do
    sign_in_with_github @user, true
    visit root_path
    page.has_content? 'Show | Edit | Delete'
  end

  test 'projects do not have edit, show and destroy options when not logged in' do
    visit root_path
    page.has_no_text? 'Show | Edit | Delete'
  end

  test 'editing a project updates its attributes in database' do
    sign_in_with_github @user, true
    visit root_path
    first('.project').has_content? @project.title
    @new_project = FactoryGirl.build(:project) # Use string instead of object
    first('.project').click_link('Edit')
    within('.form-horizontal') do
      fill_in 'Title', with: @new_project.title
      click_button 'Update Project'
    end
    @project.reload
    assert_match @project.title, @new_project.title
  end

  test 'destroying a project removes it from the database' do
    sign_in_with_github @user, true
    visit root_path
    assert_difference 'Project.count', -1 do
      first('.project').click_link('Delete')
      # Need to accept js confirmation here?
    end
  end
end
