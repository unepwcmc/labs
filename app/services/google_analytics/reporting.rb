# frozen_string_literal: true

require 'google/apis/analyticsreporting_v4'

class GoogleAnalytics::Reporting < GoogleAnalytics::Base
  ANALYTICS = Google::Apis::AnalyticsreportingV4

  # Default number of times which Google will retry calling the API
  Google::Apis::RequestOptions.default.retries = 3

  # date default to 3 months ago (90 days) for fetching the user count per product
  def initialize(from_date = 3.months.ago)
    @analytics = ANALYTICS::AnalyticsReportingService.new
    
    # Authorise with our read-only credentials
    @analytics.authorization = google_authorization

    # Google API only accepts dates in 'YYYY-MM-DD' format
    @from_date = from_date.strftime('%Y-%m-%d')
  end

  def new_request(google_tracking_code)
    request = ANALYTICS::GetReportsRequest.new(
      { report_requests: [new_report_request(google_tracking_code)] }
    )

    @analytics.batch_get_reports(request)
  end

  private

  def date_range
    today = Date.today.strftime('%Y-%m-%d')

    ANALYTICS::DateRange.new(
      start_date: @from_date,
      end_date: today
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
