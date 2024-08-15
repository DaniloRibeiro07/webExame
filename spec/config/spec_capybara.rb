# frozen_string_literal: true

require 'capybara/rspec'
require 'selenium-webdriver'

chrome_options = Selenium::WebDriver::Chrome::Options.new
chrome_options.add_argument('--disable-notifications')

Capybara.register_driver :selenium_remote_chrome do |app|
  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url: 'http://chrome-server:4444',
                                 options: chrome_options)
end

Capybara.default_driver = :selenium_remote_chrome

LOCAL_PORT = 8200
Capybara.configure do |config|
  config.default_max_wait_time = 5 # Tempo máximo de espera para elementos aparecerem
  config.server_host = 'rubyWebExame'
  config.server_port = LOCAL_PORT
  config.app_host = "http://rubyWebExame:#{LOCAL_PORT}"
end

RSpec.configure do |config|
  config.define_derived_metadata(file_path: %r{/spec/system/}) do |metadata|
    Capybara.app = WebApp
    metadata[:type] = :system
  end
end
