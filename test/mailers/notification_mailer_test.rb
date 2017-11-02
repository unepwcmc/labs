require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test "email notification" do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project, title: "Example project title")
    email = NotificationMailer.notify_team_of_new_project_code(project, '3.14159265', user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['no-reply@unep-wcmc.org'], email.from
    assert_equal ['informatics@unep-wcmc.org'], email.to
    assert_equal "Labs: #{project.title} Project Code alteration", email.subject

  end
end
