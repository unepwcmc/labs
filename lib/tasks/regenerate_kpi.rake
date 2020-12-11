# frozen_string_literal: true

namespace :kpi do
  task regenerate: :environment do
    Rails.logger.info('Regenerating KPI page values...')
    Kpi.refresh_values
    Rails.logger.info('Regenerated')
  end
end
