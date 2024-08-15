# frozen_string_literal: true

require './app/controllers/application_controller'

describe 'GET api/V1/exams' do
  context 'with sucess' do
    it 'with exams json' do
      csv_data = File.open './spec/support/exam_data_simple.csv'
      ImportCsvToBd.import_csv csv_data.read
      json_data = File.open('./spec/support/exam_data_simple.json').read.gsub("\n", '').gsub(/\s+(?=[^\w])/, '')

      get '/api/V1/exams'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq json_data
    end

    it 'no has exams' do
      get '/api/V1/exams'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq '[]'
    end
  end
end
