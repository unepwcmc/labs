class NotificationMailer < ApplicationMailer

  @@admin = Rails.application.secrets.notification_email_recipient_address

  def notify_team_of_project_code_alteration(project)
    @project = project
    mail(to: @@admin, subject: "LABS: #{@project.title} project code alteration")
  end

end
