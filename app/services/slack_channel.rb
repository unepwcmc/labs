require 'httparty'
require 'yaml'

class SlackChannel
  def self.post channel, message
    url = Rails.application.secrets.slack_notification_webhook_url
 
    payload = {
      channel: channel, 
      username: "New Comment in #{channel}", 
      text: message, 
      icon_emoji: ":envelope:"
    }

    response = HTTParty.post(url, { body: { payload: payload.to_json }})
  end
end