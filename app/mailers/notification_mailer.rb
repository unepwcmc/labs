class NotificationMailer < ApplicationMailer
  @@admin = Rails.application.secrets.notification_email_recipient_address

  def notify_team_of_new_project_code(project, existing_project_code, current_user)
    @project = project
    @existing_project_code = existing_project_code
    @current_user = current_user
    mail(to: @@admin, subject: "Labs: #{@project.title} Project Code alteration")
  end

end
