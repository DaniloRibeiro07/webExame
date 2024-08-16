# frozen_string_literal: true

require 'sinatra/base'
require './db/db'
require './app/helpers/import_csv_to_bd'
require './app/jobs/import_csv_job'

class WebApp < Sinatra::Base
  set :views, './app/views/'
  set :public_folder, './app/public/'

  get '/' do
    erb :layout
  end

  get '/api/V1/exams' do
    content_type :json

    Exam.all.map do |exam|
      exam.to_json('callback', relations: { patient: { excepts: ['id', 'cpf', 'date_of_birth', 'city', 'state', 'email', 'address'] }, doctor: { excepts: ['id', 'email', 'crm', 'crm_state'] }}, excepts: ['id'])
    end.to_json
  end

  get '/api/V1/exam/:token' do
    content_type :json
    result = Exam.find(token: params['token'])
    return {}.to_json unless result

    result[0].to_json(relations: { patient: { excepts: ['id'] }, doctor: { excepts: ['id'] },
                                   exam_result: { excepts: ['id'] } }, excepts: ['id'])
  end

  post '/uploadCSV' do
    file_code = SecureRandom.hex(10)
    File.open("./tmp/#{file_code}.csv", 'w') do |f|
      f.write request.body.read
    end
    ImportCsvJob.perform_async file_code
  end

  run! if app_file == $PROGRAM_NAME
end
