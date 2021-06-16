# frozen_string_literal: true

require 'google/apis/analyticsreporting_v4'
require 'googleauth'

class GoogleAnalytics
  ANALYTICS = Google::Apis::AnalyticsreportingV4

  # Default number of times which Google will retry calling the API
  Google::Apis::RequestOptions.default.retries = 3

  # date default to 3 months ago (90 days) for fetching the user count per product
  def initialize(date = 3.months.ago)
    @analytics = ANALYTICS::AnalyticsReportingService.new
    # Authorise with our read-only credentials
    @analytics.authorization = google_authorization
    @date = date.strftime('%Y-%m-%d')
    @date_range = date_range
    @dimension = dimension
    @metric = metric
  end

  def get_user_count(google_tracking_code)
    request = ANALYTICS::GetReportsRequest.new(
      { report_requests: [new_report_request(google_tracking_code)] }
    )

    @analytics.batch_get_reports(request)
  end

  private

  def google_authorization
    # Create service account credentials
    #
    # You will need a copy of the credentials JSON in the root of your repository
    Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open('service_account_credentials.json'),
      scope: 'https://www.googleapis.com/auth/analytics.readonly'
    )
  end

  def date_range
    ANALYTICS::DateRange.new(
      start_date: @date,
      end_date: Date.today.strftime('%Y-%m-%d')
    )
  end

  def dimension
    ANALYTICS::Dimension.new(
      name: "ga:browser"
    )
  end

  def metric 
    ANALYTICS::Metric.new(
      expression: "ga:users"
    )
  end

  def new_report_request(google_tracking_code)
    ANALYTICS::ReportRequest.new(
      view_id: google_tracking_code,
      sampling_level: 'DEFAULT',
      filters_expression: "ga:country==United Kingdom",
      date_ranges: [date_range],
      metrics: [metric],
      dimensions: [dimension]
    )
  end
end
