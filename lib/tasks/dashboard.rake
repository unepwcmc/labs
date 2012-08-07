namespace :dashboard do
  desc "Update percentages"
  task :update_all => :environment do
    Rake::Task['dashboard:update_toggl_percentages'].invoke
    Rake::Task['dashboard:update_deadlines_widget'].invoke
    Rake::Task['dashboard:update_pivotal_tracker_widget'].invoke
    Rake::Task['dashboard:update_spiceworks_widget'].invoke
    Rake::Task['dashboard:update_nagios'].invoke
  end

  desc "Update toggl budget percentages"
  task :update_toggl_percentages => :environment do
    Project.update_toggl_percentages
  end
  desc "Update deadlines widget"
  task :update_deadlines_widget => :environment do
    Project.update_deadlines_widget
  end
  desc "Update toggl budget percentages"
  task :update_pivotal_tracker_widget => :environment do
    Project.update_pivotal_tracker_widget
  end
  desc "Update toggl budget percentages"
  task :update_spiceworks_widget => :environment do
    Project.update_spiceworks_widget
  end
end
