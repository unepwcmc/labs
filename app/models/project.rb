class Project < ActiveRecord::Base
  has_attached_file :screenshot, :styles => { :medium => "280x200", :thumb => "100x100>" }

  CONFIG = YAML::load( File.open( Rails.root.join('config/config.yml') ) )['config']

  def self.top_3
    response = HTTParty.get('https://api.github.com/users/unepwcmc/repos?sort=pushed')

    response.map{ |i| i['name'] }.map{ |n| Project.find_by_github_id(n) }.compact[0..3]
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


