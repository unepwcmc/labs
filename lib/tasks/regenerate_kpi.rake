# frozen_string_literal: true

namespace :kpi do
  task regenerate: :environment do
    puts 'Regenerating KPI page values...'
    Kpi.refresh_values
    puts 'Regenerated'
    
    puts 'Importing latest GitHub commit dates for each product...'
    Github.import_commit_dates
    puts 'Imported'
  end
end
