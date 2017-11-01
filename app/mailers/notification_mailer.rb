class NotificationMailer < ApplicationMailer
  ADMIN = Rails.application.secrets.notification_email_recipient_address

  def notify_team_of_new_project_code(project, existing_project_code, current_user)
    @project = project
    @existing_project_code = existing_project_code
    @current_user = current_user
    mail(to: ADMIN, subject: "Labs: #{@project.title} Project Code alteration")
  end

end
