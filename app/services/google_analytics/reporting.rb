# frozen_string_literal: true

class GoogleAnalytics::Reporting < GoogleAnalytics::Base
  ANALYTICS = Google::Apis::AnalyticsreportingV4

  # date defaults to 3 months ago (90 days) for fetching the user count per product
  def initialize(google_tracking_code, from_date = 3.months.ago)
    @analytics = ANALYTICS::AnalyticsReportingService.new

    @analytics.authorization = google_authorization

    @google_tracking_code = google_tracking_code
    # Google API only accepts dates in 'YYYY-MM-DD' format
    @from_date = from_date.strftime('%Y-%m-%d')
  end

  def send_request
    raw_response = @analytics.batch_get_reports(new_request)

    GoogleAnalytics::Processor.parse_response_for_total_users(raw_response)
  rescue Google::Apis::ClientError 
    # Currently no differentiation between incorrect tracking codes and other issues
    Rails.logger.info('Check your product tracking code - is it correct?')
    false
  rescue BadResponseError
    Rails.logger.info('Response could not be parsed properly')
    false
  end

  private

  def new_request
    ANALYTICS::GetReportsRequest.new(
      { report_requests: [new_report_request] }
    )
  end

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

  def new_report_request
    ANALYTICS::ReportRequest.new(
      view_id: @google_tracking_code,
      sampling_level: 'DEFAULT',
      date_ranges: [date_range],
      metrics: [metric],
      dimensions: [dimension]
    )
  end
end
