# frozen_string_literal: true

require 'sinatra/base'
require './db/db'
require './app/helpers/import_csv_to_bd'
require 'sinatra/cross_origin'

class WebApp < Sinatra::Base
  set :views, './app/views/'

  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  get '/' do
    erb :index, layout: :layout
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

  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end

  run! if app_file == $PROGRAM_NAME
end
