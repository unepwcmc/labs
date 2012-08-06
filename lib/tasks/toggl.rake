class Date
  # UNIX epoch date, because monkey patching is cool
  def self.first
    Date.parse('1970-1-1')
  end
end

namespace :toggl do
  desc "Update percentages"
  task :update_percentages do
    API_KEYS = ['f9371ea5d53955cd243186d0e6723a9a']
    projects = {}

    # Get hours worked in projects from each user
    API_KEYS.each do |key|
      toggl_interface = Toggl.new(key, "api_token")
      toggl_interface.time_entries({"start_date" => Date.first, "end_date" => Date.today}).each do |time_entry|
        project_id = time_entry['project'].try(:[],'id')
        # Init project counter if not already inserted
        projects[project_id] = unless projects[project_id].present?

        # Insert duration into project
        projects[project_id] += time_entry['duration']
      end
    end

    puts projects
  end
end
