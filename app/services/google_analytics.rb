# frozen_string_literal: true

require 'google/apis/analyticsreporting_v4'
require 'googleauth'

class GoogleAnalytics
  ANALYTICS = Google::Api::AnalyticsreportingV4

  def initialize
    @analytics = ANALYTICS::AnalyticsReportingService.new
    # Authorise with our read-only credentials
    @analytics.authorization = google_authorization
  end

  def get_user_count
  
  end

  private

  def google_authorization
    # Create service account credentials
    # You will need a copy of the credentials JSON in the root of your repository
    # (or wherever else you want to place it)
    Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open('service_account_credentials.json'),
      scope: 'https://www.googleapis.com/auth/analytics.readonly'
    )
  end
end
