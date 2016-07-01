require 'httparty'
require 'yaml'

class SlackChannel

  def self.closing_notification(obj, _params)
    closing_flag = obj.closing
    if obj.update_attributes(_params)
      if closing_flag != obj.closing
        status = obj.closing ? "scheduled for close down" : "unscheduled for close down"
        message = "*#{obj.name}* #{obj.class.name.downcase} has been #{status}"
        post("#labs", "Labs detective (#{Rails.env})", message, ":squirrel:")
      end
      yield
    end
  end

  def self.post channel, username, message, icon
    url = Rails.application.secrets.slack_notification_webhook_url

    payload = {
      channel: channel,
      username: username,
      text: message,
      icon_emoji: icon
    }

    response = HTTParty.post(url, { body: { payload: payload.to_json }})
  end
end
