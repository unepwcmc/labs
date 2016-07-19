source 'http://rubygems.org'
ruby '2.2.3'
gem 'rails', '~> 4.2.5.2'
#gem 'rake', '0.8.7'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg', '~> 0.18.3'
gem 'httparty', '~> 0.13.7'
gem 'devise', '~> 4.0.0'
gem 'uglifier', '~> 2.7.2'
gem 'jquery-rails'
gem 'carrierwave'
gem 'mini_magick', '~> 4.3.6'
gem 'omniauth-github'
gem 'pg_array_parser'
gem 'pg_search', '~> 1.0.5'
gem 'select2-rails', '3.5.9.3'
#gem "paranoia", '~> 2.1.4'
gem "paranoia", github: "rubysherpas/paranoia", branch: "rails5"
gem 'gon', '~> 6.0.1'
gem 'nested_form'
gem 'bootstrap-sass', '~> 3.3.5.1'
gem 'sass-rails', github: 'rails/sass-rails', branch: 'master'
# https://github.com/rweng/jquery-datatables-rails/issues/153
gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
gem 'bootstrap-datepicker-rails', '~> 1.5.0'
gem 'pg_csv', '~> 0.2'
gem 'kramdown', '~> 1.9.0'
gem 'sanitize'
gem 'domain_uploader', github: 'unepwcmc/domain_uploader'
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
  gem 'capistrano', '~> 3.4', require: false
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rvm',   '~> 0.1', require: false
  gem 'capistrano-sidekiq'
  gem 'capistrano-maintenance', '~> 1.0', require: false
  gem 'capistrano-passenger', '~> 0.1.1', require: false
  gem 'slackistrano', '~> 1.0.0', require: false
  gem 'whenever'
  #gem 'exception_notification', :git => 'https://github.com/smartinez87/exception_notification.git'
  gem 'slack-notifier'
  gem "font-awesome-rails", '~> 4.6.0.0'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
  gem 'capybara'
  gem 'shoulda'
  gem 'mocha', '~> 1.1.0'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'webmock', '~> 1.18.0', require: false
  gem "codeclimate-test-reporter", require: nil
  gem 'simplecov', '>=0.9', :require => false
end

group :development do
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'spring'
  gem 'rubocop', require: false
end

group :test, :development do
  gem 'faker'
  gem 'byebug'
end


#gem "toggl", :git => "git://github.com/atog/toggl.git"
