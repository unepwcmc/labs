require 'test_helper'

class SlackChannelTest < ActiveSupport::TestCase

    test "post should call HTTParty" do
      url = Rails.application.secrets.slack_notification_webhook_url
      payload = "{\"channel\":\"channel\",\"username\":\"username\",\"text\":\"message\",\"icon_emoji\":\"icon\"}"

      HTTParty.expects(:post).with(url, { body: { payload: payload }})
      SlackChannel.post "channel", "username", "message", "icon"
    end
end
