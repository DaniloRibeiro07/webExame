# frozen_string_literal: true

require 'sinatra/base'

class WebApp < Sinatra::Base
  get '/' do
    'Hello world!'
  end

  run! if app_file == $PROGRAM_NAME
end
