namespace :toggle do
  desc "Update percentages"
  task :update_percentages do
    toggl_interface = Toggl.new('f9371ea5d53955cd243186d0e6723a9a', "blah")

    puts toggl_interface.time_entries
  end
end
