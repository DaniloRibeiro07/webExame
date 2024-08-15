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

  get '/exam/:token' do
    content_type :json
    result = Exam.find(token: params['token'])
    return {}.to_json unless result

    result[0].to_json(relations: { patient: { excepts: ['id'] }, doctor: { excepts: ['id'] },
                                   exam_result: { excepts: ['id'] } }, excepts: ['id'])
  end

  run! if app_file == $PROGRAM_NAME
end
