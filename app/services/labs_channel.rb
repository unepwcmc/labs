require 'httparty'

class LabsChannel
  def self.post message
    url = "https://hooks.slack.com/services/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"
    
    payload = {
      channel: "#labs", 
      username: "New Comment in Labs", 
      text: message, 
      icon_emoji: ":envelope:"
    }

    response = HTTParty.post(url, { body: { payload: payload.to_json }})
  end
end