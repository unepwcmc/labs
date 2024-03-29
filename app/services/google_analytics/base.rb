# frozen_string_literal: true

module GoogleAnalytics
  class BadResponseError < StandardError
    def message
     'Malformed hash - response could not be parsed properly'
    end
  end
  
  class Base
    private

    def google_authorization
      # Authorise against service account credentials
      #
      # You will need a copy of the credentials JSON in the root of your repository
      Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open('service_account_credentials.json'),
        scope: 'https://www.googleapis.com/auth/analytics.readonly'
      )
    end
  end
end
