# frozen_string_literal: true

require 'sinatra/base'
require './db/db'
require './app/helpers/import_csv_to_bd'

class WebApp < Sinatra::Base
  set :views, './app/views/'

  get '/' do
    erb :index, layout: :layout
  end

  get '/exams' do
    erb :exams, layout: :layout
  end

  get '/api/V1/exams' do
    content_type :json
    Exam.all.map do |exam|
      exam.to_json('callback', relations: { patient: { excepts: ['id'] }, doctor: { excepts: ['id'] },
                                            exam_result: { excepts: ['id'] } }, excepts: ['id'])
    end.to_json
  end

  get '/api/V1/exam/:token' do
    content_type :json
    result = Exam.find(token: params['token'])
    return {}.to_json unless result

    result[0].to_json(relations: { patient: { excepts: ['id'] }, doctor: { excepts: ['id'] },
                                   exam_result: { excepts: ['id'] } }, excepts: ['id'])
  end

  run! if app_file == $PROGRAM_NAME
end
