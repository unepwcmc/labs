# frozen_string_literal: true

class ProjectsHelperTest < ActionView::TestCase
  def test_jumbotron_present_when_no_review
    @project = FactoryGirl.create(:project)
    assert_match /^<div.* class=".*jumbotron.*">/, review_jumbotron
  end

  def test_jumbotron_absent_when_review
    @project = FactoryGirl.create(:project)
    @review = FactoryGirl.create(:review, project: @project)
    assert_no_match /^<div.* class=".*jumbotron.*">/, review_jumbotron
  end
end
