namespace :deadlines do
  desc "Update deadlines widget"
  task :update_widgets => :environment do
    Project.update_deadlines_widget
  end
end
