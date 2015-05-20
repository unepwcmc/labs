require 'httparty'
require 'yaml'

class SlackChannel
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
