# frozen_string_literal: true

require 'google/apis/analyticsreporting_v4'
require 'googleauth'

class GoogleAnalytics
  ANALYTICS = Google::Apis::AnalyticsreportingV4

  # Default number of times which Google will retry calling the API
  Google::Apis::RequestOptions.default.retries = 3

  def initialize
    @analytics = ANALYTICS::AnalyticsReportingService.new
    # Authorise with our read-only credentials
    @analytics.authorization = google_authorization
    @date_range = date_range
    @dimension = dimension
    @metric = metric
  end

  def date_range
    # Retrieves data from the last 90 days
    Google::Apis::AnalyticsreportingV4::DateRange.new(
      start_date: 3.months.ago,
      end_date: DateTime.now
    )
  end

  def dimension
    Google::Apis::AnalyticsreportingV4::Dimension.new(
      name: "ga:browser"
    )
  end

  def metric 
    Google::Apis::AnalyticsreportingV4::Metric.new(
      expression: "ga:users"
    )
  end

  def get_user_count
    Project.find_each do |project|

    end
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
