# frozen_string_literal: true

require 'sinatra/base'
require './db/db'
require './app/helpers/import_csv_to_bd'

class WebApp < Sinatra::Base
  get '/' do
    'Hello world!'
  end

  get '/exams' do
    content_type :json
    Exam.all.map do |exam|
      exam.to_json('callback', relations: { patient: { excepts: ['id'] }, doctor: { excepts: ['id'] },
                                            exam_result: { excepts: ['id'] } }, excepts: ['id'])
    end.to_json
  end

  run! if app_file == $PROGRAM_NAME
end
