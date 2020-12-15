# frozen_string_literal: true

namespace :kpi do
  task regenerate: :environment do
    Rails.logger.info('Regenerating KPI page values...')
    Kpi.refresh_values
    Rails.logger.info('Regenerated')
    
    Rails.logger.info('Importing latest GitHub commit dates for each project...')
    Github.import_commit_dates
    Rails.logger.info('Imported')
  end
end
