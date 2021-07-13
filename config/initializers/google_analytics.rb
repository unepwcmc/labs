require 'google/apis/analyticsreporting_v4'

# Default number of times which Google will retry calling the API
Google::Apis::RequestOptions.default.retries = 3