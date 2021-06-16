module GoogleAnalytics
  module Processor 
    extend self

    def parse_response_for_total_users(response)
      # Google Analytics API returns back a very ugly hash
      data = response.to_h[:reports]

      required_metric = data.first.dig(:data, :totals)

      required_metric.first[:values].first.to_i
    end
  end
end