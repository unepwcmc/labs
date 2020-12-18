# frozen_string_literal: true

# NB: The analytics admin library will change with regularity, as it is in alpha
# so will likely break with updates - make sure to keep on top of gem upgrades!
require 'google/apis/analyticsadmin_v1alpha'
require 'googleauth'

class GoogleAnalyticsManagement 
  ANALYTICS_ADMIN = Google::Apis::AnalyticsadminV1alpha

  # Default number of times which Google will retry calling the API
  Google::Apis::RequestOptions.default.retries = 3

  def initialize
    @analytics = ANALYTICS_ADMIN::GoogleAnalyticsAdminService.new
    # Authorise with our read-only credentials
    @analytics.authorization = google_authorization
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