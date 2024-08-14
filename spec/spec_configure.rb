# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Db', 'db'
  add_filter '/spec/'
end

require 'rack/test'
require './db/db'

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :request

  config.define_derived_metadata(file_path: %r{/spec/requests/}) do |metadata|
    def app
      WebApp
    end
    metadata[:type] = :request
  end

  config.before(:suite) do
    ENV['TEST'] = 'true'
    Db.reset
  end

  config.before do
    Db.truncate
  end
end
