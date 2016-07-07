namespace :update_projects do
  task :rails_version => :environment do
    Project.all.each do |project|
      github = Github.new
      repo = project.github_identifier.split('/').last
      rails_version = github.get_rails_version(repo)
      project.update_attributes(rails_version: rails_version) if rails_version.present?
    end
  end

  task :ruby_version => :environment do
    Project.all.each do |project|
      github = Github.new
      repo = project.github_identifier.split('/').last
      ruby_version = github.get_ruby_version(repo)
      project.update_attributes(ruby_version: ruby_version) if ruby_version.present?
    end
  end
end
