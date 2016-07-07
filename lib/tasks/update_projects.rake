namespace :update_projects do
  task :rails_version, [:arg] => :environment do |t, args|
    Project.all.each do |project|
      github = Github.new
      repo = project.github_identifier.split('/').last
      rails_version = github.get_rails_version(repo)
      if rails_version.present? && rails_version != project.rails_version
        if project.update_attributes(rails_version: rails_version)
          notice = ", UPDATED"
        else
          notice = ", ERRORED"
        end
      end
      if args[:arg] == 'verbose'
        notice = "#{repo}, fetched rails version: #{rails_version}#{notice}"
        puts notice
      end
    end
  end

  task :ruby_version, [:arg] => :environment do |t, args|
    Project.all.each do |project|
      github = Github.new
      repo = project.github_identifier.split('/').last
      ruby_version = github.get_ruby_version(repo)
      if ruby_version.present? && ruby_version != project.ruby_version
        if project.update_attributes(ruby_version: ruby_version)
          notice = ", UPDATED"
        else
          notice = ", ERRORED"
        end
      end
      if args[:arg] == 'verbose'
        notice = "#{repo}, fetched ruby version: #{ruby_version}#{notice}"
        puts notice
      end
    end
  end
end
