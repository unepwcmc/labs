require 'httparty'
require 'yaml'

class SlackChannel
  def self.post channel, message
    url = "https://hooks.slack.com/services/T028F7AGY/B040KHJPX/#{Rails.application.secrets.slack_channel_notification_token}"
 
    payload = {
      channel: channel, 
      username: "New Comment in #{channel}", 
      text: message, 
      icon_emoji: ":envelope:"
    }

    response = HTTParty.post(url, { body: { payload: payload.to_json }})
  end
end