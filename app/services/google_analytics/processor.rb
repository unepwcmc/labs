module GoogleAnalytics
  module Processor 
    extend self

    class BadResponseError < StandardError; end

    def parse_response_for_total_users(response)
      # Google Analytics API returns back a very ugly hash
      data = response.to_h[:reports]

      required_metric = data.first.dig(:data, :totals)

      if required_metric.nil?
        raise BadResponseError, 'Malformed hash - could not find the desired values'
      end 

      required_metric.first[:values].first.to_i
    end
  end
end