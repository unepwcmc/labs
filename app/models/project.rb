class Project < ActiveRecord::Base
  has_attached_file :screenshot, :styles => { :medium => "280x200", :thumb => "100x100>" }
  TITLE_WIDGET_IDS = [70057, 70058, 70059]
  SPICEWORK_OPEN_ID = 70265
  SPICEWORK_CLOSED_ID = 70264
  TOGGL_API_KEYS = CONFIG['toggl_tokens']
  BUDGET_PARAM_IDS = [70085, 70086, 70071]
  BUDGET_WIDGET_IDS = [70084, 70085, 70075]

  def self.top_3
    response = HTTParty.get('https://api.github.com/orgs/unepwcmc/repos?sort=pushed',
                           :basic_auth => {
                            :username => CONFIG['gh_un'],
                            :password => CONFIG['gh_pw']
                           })
    # Sort by push date, because github won't
    response = response.sort do |x,y|
      DateTime.parse(y['pushed_at'] || '1970-01-01') <=>
        DateTime.parse(x['pushed_at'] || '1970-01-01')
    end

    labs_projects_names_in_order = response.map{ |e| e['name'] }

    #fetch all from db and sort according to github order
    labs_projects = Project.where(:github_id => labs_projects_names_in_order).all.
      sort do |a,b|
        labs_projects_names_in_order.index(a.github_id) <=>
          labs_projects_names_in_order.index(b.github_id)
      end

    top_3 = []
    labs_projects.each_with_index do |p, idx|
      #if multiple projects share the same pivotal tracker id, take just the 1st one
      if p.pivotal_tracker_id.nil? || idx == labs_projects.index do |pp|
          pp.pivotal_tracker_id == p.pivotal_tracker_id
        end
        top_3 << p
      end
      break unless top_3.size < 3
    end
    top_3
  end

  def self.update_pivotal_tracker_widget
    projects = Project.top_3
    widget_ids = [70338, 70339, 70340]
    ducksboard_dashboard_api_url = CONFIG['ducksboard_dashboard_api_url']
    ducksboard_api_token = CONFIG['ducksboard_api_token']
    widget_ids.each_with_index do |id, idx|
      project = projects[idx]
      pt_id = project.try(:pivotal_tracker_id)
      pt_id ||= 0
      puts "updating widget #{id} with project #{pt_id}"
      response = HTTParty.put("#{ducksboard_dashboard_api_url}/#{id}",
        :basic_auth => {
          :password => 'x',
          :username => ducksboard_api_token
        },
        :body =>  {
          :content => {:project_id => pt_id},
          :widget => {:title => "PT stories for #{project.try(:title)}"}
        }.to_json
      )
      puts response.inspect
    end
  end

  def self.update_deadlines_widget
    Project.top_3.each_with_index do |project, i|
      date = project.deadline
      date = Date.today + 7 if date.nil?
      target = date.strftime("%d %b %y, 09:00")
      response = HTTParty.put("#{CONFIG['ducksboard_dashboard_api_url']}/#{TITLE_WIDGET_IDS[i]}",
        :basic_auth => {
          :password => 'x',
          :username => CONFIG['ducksboard_api_token']
        },
        :body =>  "{\"content\": {\"event\": \"#{project.title}\", \"target\": \"#{target}\"}}"
      )
      puts response.inspect
    end
  end

  def self.update_spiceworks_widget
    # Open tickets
    csv_text = HTTParty.get('http://spiceworks.unep-wcmc.org/opentickets.csv').body
    open_count = CSV.parse(csv_text).count - 1
    response = HTTParty.post("https://push.ducksboard.com/v/#{SPICEWORK_OPEN_ID}", :basic_auth => {
        :username => CONFIG['ducksboard_api_token'],
        :password => 'x'
      },
      :body => "{\"value\": #{open_count}}"
    )
    puts open_count
    puts response

    # Closed last month tickets
    csv_text = HTTParty.get('http://spiceworks.unep-wcmc.org/closedtickets.csv').body
    closed_count = CSV.parse(csv_text).count - 1
    response = HTTParty.post("https://push.ducksboard.com/v/#{SPICEWORK_CLOSED_ID}", :basic_auth => {
        :username => CONFIG['ducksboard_api_token'],
        :password => 'x'
      },
      :body => "{\"value\": #{closed_count}}"
    )
    puts closed_count
    puts response
  end

  # Calculates the percentage of the 3 most recent projects has been spent in toggl,
  # then updates the widget
  def self.update_toggl_percentages
    project_stats = {}

    top_3_projects = Project.top_3
    top_3_toggl_ids = top_3_projects.map(&:toggl_id)

    # Get hours worked in projects from each user
    TOGGL_API_KEYS.each do |key|
      toggl_interface = Toggl.new(key, "api_token")

      # Get time spent
      toggl_interface.time_entries({"start_date" => Date.parse('1970-1-1'), "end_date" => Date.today + 1}).each do |time_entry|
        project_id = time_entry['project'].try(:[],'id')
        if top_3_toggl_ids.include? project_id 
          # Init project counter if not already inserted
          project_stats[project_id] = {:spent => 0, :estimated => 0} unless project_stats[project_id].present?

          # Current time entries show up as massive negative numbers, so ignore
          if time_entry['duration'].to_i > 0
            # Insert duration into project
            project_stats[project_id][:spent] += time_entry['duration']
          end
        end
      end

      # Get time estimates for project
      toggl_interface.projects.each do |project|
        project_id = project['id']
        if top_3_toggl_ids.include? project_id 
          # Init project counter if not already inserted
          project_stats[project_id] = {:spent => 0, :estimated => 0} unless project_stats[project_id].present?

          # Set estimated
          project_stats[project_id][:estimated] = project['estimated_workhours']*60*60 if project['estimated_workhours'].present?
        end
      end
    end

    # Post top 3 project stats to widgets
    top_3_projects.each_with_index do |project, i|
      # get project toggle id
      stats = project_stats[project.toggl_id]

      # calculate percentage from project_stats hash
      percentage = 0
      percentage = stats[:spent].to_f/stats[:estimated] if stats[:estimated] > 0
      puts "#{project.title} (#{project.toggl_id}): #{stats[:spent].to_f}/#{stats[:estimated]} = #{percentage}"

      response = HTTParty.post("https://push.ducksboard.com/v/#{BUDGET_PARAM_IDS[i]}", :basic_auth => {
          :username => CONFIG['ducksboard_api_token'],
          :password => 'x'
        },
        :body => {:value => percentage}.to_json
      )

      # Update widget title
      response = HTTParty.put("#{CONFIG['ducksboard_dashboard_api_url']}/#{BUDGET_WIDGET_IDS[i]}",
        :basic_auth => {
          :username => CONFIG['ducksboard_api_token'],
          :password => 'x'
        },
        :body => {:widget => {:title => project.title + ' budget'}}.to_json
      )
    end
  end
end

# == Schema Information
#
# Table name: projects
#
#  id                      :integer          not null, primary key
#  title                   :string(255)
#  description             :text
#  url                     :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  screenshot_file_name    :string(255)
#  screenshot_content_type :string(255)
#  screenshot_file_size    :integer
#  screenshot_updated_at   :datetime
#  github_id               :string(255)
#  pivotal_tracker_id      :integer
#  toggl_id                :integer
#  deadline                :date
#


