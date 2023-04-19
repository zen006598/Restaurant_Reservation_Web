require 'capybara/rspec'

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.javascript_driver = :selenium_chrome

RSpec.configure do |config|
  config.include Capybara::DSL
  # config.before(:each, type: :system) do
  #   driven_by :selenium_chrome_headless
  # end
end

# Capybara.register_driver :selenium_chrome_headless do |app|
#   options = Selenium::WebDriver::Chrome::Options.new(
#     args: %w[headless disable-gpu no-sandbox]
#   )

#   Capybara::Selenium::Driver.new(
#     app,
#     browser: :chrome,
#     options: options
#   )
# end