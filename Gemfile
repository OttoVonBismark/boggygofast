source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 6.0.1'
gem 'bcrypt'
gem 'bootstrap-sass'
gem 'jquery-rails'
gem 'faker'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'puma', '>= 4.3.11'
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 5.0.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'friendly_id'
gem 'listen', '>= 3.0.5', '< 3.2'
gem 'bootsnap'
gem 'pg'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rails-controller-testing', '>= 1.0.4'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  # gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'minitest-reporters', '1.1.14'
  gem 'guard'
  gem 'guard-minitest'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
