source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.4'

gem 'rails', '~> 7.2.1'
# json 3.x removed an option ActiveSupport 7.2 still passes
gem 'json', '< 3'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 2.0'
# The original asset pipeline
gem 'sprockets-rails'
# Use Puma as the app server
gem 'puma', '>= 6.0'
# Use SCSS for stylesheets (Dart Sass; sassc/libsass is deprecated)
gem 'dartsass-sprockets'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  gem 'debug', platforms: [:mri, :windows], require: 'debug/prelude'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
end

group :test do
  # Rails 7.2 is not compatible with minitest 6
  gem 'minitest', '< 6'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
end

# Customizations
gem 'bootstrap', '~> 5.3'
gem 'jquery-rails'
gem 'bootstrap_form', '~> 5.4'
gem 'font-awesome-rails'
gem 'rsolr'
gem 'cocoon'
gem 'will_paginate'
gem 'devise', '~> 4.9'
gem 'paper_trail', '~> 16.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:windows, :jruby]
