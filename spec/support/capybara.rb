Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new app, browser: :chrome,
    options: Selenium::WebDriver::Chrome::Options.new(args: %w[disable-gpu])
end

Capybara.javascript_driver = :chrome

RSpec.configure do |config|
  config.include Capybara::DSL
end
