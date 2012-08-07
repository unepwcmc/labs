class Project < ActiveRecord::Base
  has_attached_file :screenshot, :styles => { :medium => "280x200", :thumb => "100x100>" }
  TITLE_WIDGET_IDS = [70057, 70058, 70059]
  SPICEWORK_OPEN_ID = 70265
  SPICEWORK_CLOSED_ID = 70264

  def self.top_3
    response = HTTParty.get('https://api.github.com/orgs/unepwcmc/repos?sort=pushed',
                           :basic_auth => {
                            :username => CONFIG['gh_un'],
                            :password => CONFIG['gh_pw']
                           })
    projects = []
    response.map{ |i| i['name'] }.each do |r|
      if (p = Project.find_by_github_id(r))
        projects << p
      end
      break if projects.size == 3
    end
    projects
  end

  def self.update_pivotal_tracker_widget
    pivotal_tracker_ids = Project.top_3.map(&:pivotal_tracker_id)
    widget_ids = [70076, 70077, 70078]
    ducksboard_dashboard_api_url = CONFIG['ducksboard_dashboard_api_url']
    ducksboard_api_token = CONFIG['ducksboard_api_token']
    widget_ids.each_with_index do |id, idx|
      puts "updating widget #{id} with project #{pivotal_tracker_ids[idx]}"
      response = HTTParty.put("#{ducksboard_dashboard_api_url}/#{id}",
        :basic_auth => {
          :password => 'x',
          :username => ducksboard_api_token
        },
        :body =>  "{\"content\": {\"project_id\": #{pivotal_tracker_ids[idx]}}}"
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
    open_count = CSV.parse(csv_text).count
    response = HTTParty.post("https://push.ducksboard.com/v/#{SPICEWORK_OPEN_ID}", :basic_auth => {
        :username => CONFIG['ducksboard_api_token'],
        :password => 'x'
      },
      :body => "{\"value\": #{open_count}}"
    )

    # Closed last month tickets
    csv_text = HTTParty.get('http://spiceworks.unep-wcmc.org/closedtickets.csv').body
    closed_count = CSV.parse(csv_text).count
    response = HTTParty.post("https://push.ducksboard.com/v/#{SPICEWORK_CLOSED_ID}", :basic_auth => {
        :username => CONFIG['ducksboard_api_token'],
        :password => 'x'
      },
      :body => "{\"value\": #{closed_count}}"
    )
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


