# frozen_string_literal: true

require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :request

  config.define_derived_metadata(file_path: %r{/spec/requests/}) do |metadata|
    def app
      WebApp
    end
    metadata[:type] = :request
  end
end
