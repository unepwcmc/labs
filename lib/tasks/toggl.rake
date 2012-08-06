class Date
  # UNIX epoch date, because monkey patching is cool
  def self.first
    Date.parse('1970-1-1')
  end
end

namespace :toggl do
  desc "Update percentages"
  task :update_percentages => :environment do
    API_KEYS = CONFIG['toggl_tokens']
    project_stats = {}

    # Get hours worked in projects from each user
    API_KEYS.each do |key|
      toggl_interface = Toggl.new(key, "api_token")

      # Get time spent
      toggl_interface.time_entries({"start_date" => Date.first, "end_date" => Date.today}).each do |time_entry|
        project_id = time_entry['project'].try(:[],'id')
        # Init project counter if not already inserted
        project_stats[project_id] = {:spent => 0, :estimated => 0} unless project_stats[project_id].present?

        # Insert duration into project
        project_stats[project_id][:spent] += time_entry['duration']
      end

      # Get time estimates for project
      toggl_interface.projects.each do |project|
        project_id = project['id']
        # Init project counter if not already inserted
        project_stats[project_id] = {:spent => 0, :estimated => 0} unless project_stats[project_id].present?

        # Set estimated
        project_stats[project_id][:estimated] = project['estimated_workhours']*60*60 if project['estimated_workhours'].present?
      end
    end

    WIDGET_IDS = [70085, 70086, 70071]
    Project.top_3.each_with_index do |project, i|
      # get project toggle id
      stats = project_stats[project.toggl_id]

      # calculate percentage from project_stats hash
      percentage = 0
      percentage = stats[:spent].to_f/stats[:estimated] if stats[:estimated] > 0
      puts "#{project.title}: #{stats[:spent].to_f}/#{stats[:estimated]} = #{percentage}"

      response = HTTParty.post("https://push.ducksboard.com/v/#{WIDGET_IDS[i]}", :basic_auth => {
          :username => CONFIG['ducksboard_api_token'],
          :password => 'x'
        },
        :body => "{\"value\": #{percentage}}"
      )
    end
    puts project_stats
  end
end
