class Project < ActiveRecord::Base
  has_attached_file :screenshot, :styles => { :medium => "280x200", :thumb => "100x100>" }

  def self.top_3
    response = HTTParty.get('https://api.github.com/users/unepwcmc/repos?sort=pushed')

    response.map{ |i| i['name'] }.map{ |n| Project.find_by_github_id(n) }.compact[0..3]
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


