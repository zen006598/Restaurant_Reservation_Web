source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'
gem 'rails', '~> 7.0.4', '>= 7.0.4.3'
gem 'sprockets-rails'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'jbuilder'
gem 'redis', '~> 4.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'bootsnap', require: false

gem 'devise'
gem 'rails-i18n'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'cancancan'
gem 'font-awesome-sass', '~> 6.3.0'
gem 'simple_calendar', '~> 2.4'
gem 'validates_timeliness', '~> 7.0.0.beta1'
gem "aasm", "~> 5.5"

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '~> 6.0.0'
  gem 'factory_bot_rails'
  gem 'dotenv-rails'
  gem 'faker'
  gem 'rubocop', '~> 1.48'
  gem 'bundler-audit', '~> 0.9.1'
  gem 'brakeman'
end

group :development do
  gem 'web-console'
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'database_cleaner-active_record'
  gem "mock_redis", "~> 0.36.0"
end
gem "twsms2", "~> 1.3"
