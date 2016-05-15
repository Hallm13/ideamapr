# -*- coding: utf-8 -*-
source 'https://rubygems.org'
ruby '2.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~>4.2'
gem 'thin', group: :production
gem 'quiet_assets'

# Admin Interface
gem 'rails_admin'
gem 'activerecord-import'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'font-awesome-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
gem 'rails-backbone'

# Everybody gotta have some jQuery (UI) and Bootstrap!
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'

# Needed for default layouts
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'underscore-rails'

gem 'has_secure_token'
gem 'redis-namespace'
gem 'sidekiq'
group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'devise'
gem 'haml-rails'

group :production do
  gem 'pg'
  gem 'execjs'
  gem 'rails_12factor'
end

gem 'web-console', '~> 2.0', group: :development

group :development, :test do
  # Use sqlite3 as the database for Active Record in dev and test envs  
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'pry'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'capistrano'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'

  # Can unset when https://github.com/phusion/passenger/issues/1392 is closed.
  gem 'capistrano-passenger', '0.0.2'
  gem 'jasmine-rails'
  gem 'capistrano-sidekiq'
end

gem 'dotenv'

#testing with minitest
group :test do
  gem 'capybara-webkit'
  gem 'poltergeist'
  gem 'mocha'
  gem 'simplecov', require: false
  gem 'webmock'
  gem 'minitest-spec-rails'
  gem 'minitest-rails-capybara'
  gem 'selenium-webdriver'
end
