# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id          :integer          not null, primary key
#  project_id  :integer          not null
#  reviewer_id :integer          not null
#  result      :decimal(, )      not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  def test_result_formatted
    @question = FactoryGirl.create(:review_question)
    @project = FactoryGirl.create(:project, title: 'AAA')
    @review = FactoryGirl.create(:review, project: @project)
    assert @review.result_formatted == '0%'
  end

  def test_reviews_refreshed_after_project_update
    skip("TODO: need to mock snyk better")
    stub_request(:get, %r{https://snyk.io}).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})

    @question = FactoryGirl.create(:review_question)
    @auto_question = FactoryGirl.create(:review_question, skippable: false, auto_check: 'ruby_version?')
    @project = FactoryGirl.create(:project, ruby_version: nil)
    @review = FactoryGirl.create(:review, project: @project)
    assert @review.reload.result == 0.0
    old_result = @review.result
    @project.update_attributes(ruby_version: '2.0.0')
    assert old_result < @review.reload.result
  end

  def test_reviews_refreshed_after_instance_update
    @question = FactoryGirl.create(:review_question)
    @auto_question = FactoryGirl.create(:review_question, skippable: false, auto_check: 'production_backups?')
    @project = FactoryGirl.create(:project)
    @instance = FactoryGirl.create(:project_instance, project: @project, stage: 'Production', backup_information: nil)
    FactoryGirl.create(:installation, project_instance: @instance)
    @review = FactoryGirl.create(:review, project: @project)
    @project.reviews.reload
    assert @review.reload.result == 0.0
    old_result = @review.result
    @instance.update_attributes(backup_information: 'loads of backup')
    assert old_result < @review.reload.result
  end

  def test_reviews_refreshed_after_installation_create
    @question = FactoryGirl.create(:review_question)
    @auto_question = FactoryGirl.create(:review_question, skippable: false, auto_check: 'production_instance?')
    @project = FactoryGirl.create(:project)
    @instance = FactoryGirl.create(:project_instance, project: @project, stage: 'Production')
    @review = FactoryGirl.create(:review, project: @project)
    assert @review.reload.result == 0.0
    old_result = @review.result
    i = FactoryGirl.create(:installation, project_instance: @instance)
    assert old_result < @review.reload.result
  end

  def test_reviews_refreshed_after_installation_destroy
    @question = FactoryGirl.create(:review_question)
    @auto_question = FactoryGirl.create(:review_question, skippable: false, auto_check: 'production_instance?')
    @project = FactoryGirl.create(:project)
    @instance = FactoryGirl.create(:project_instance, project: @project, stage: 'Production')
    FactoryGirl.create(:installation, project_instance: @instance)
    @review = FactoryGirl.create(:review, project: @project)
    assert @review.reload.result > 0.0
    old_result = @review.result
    @instance.destroy
    assert old_result > @review.reload.result
  end
end
