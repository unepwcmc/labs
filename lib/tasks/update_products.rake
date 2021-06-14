namespace :update_products do
  task :rails_version, [:arg] => :environment do |t, args|
    Product.all.each do |product|
      github = Github.new
      repo = product.github_identifier.split('/').last
      rails_version = github.get_rails_version(repo)
      if rails_version.present? && rails_version != product.rails_version
        if product.update_attributes(rails_version: rails_version)
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
    Product.all.each do |product|
      github = Github.new
      repo = product.github_identifier.split('/').last
      ruby_version = github.get_ruby_version(repo)
      if ruby_version.present? && ruby_version != product.ruby_version
        if product.update_attributes(ruby_version: ruby_version)
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
