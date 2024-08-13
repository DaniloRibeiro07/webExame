# frozen_string_literal: true

require './app/models/exam'

describe 'Exam' do
  context '#importCSV' do
    it 'with sucess' do
      csv_data = File.open './spec/support/exam_data.csv'

      result = Exam.importCSV csv_data.read

      expect(result).to eq 'Sucess'
      expect(Exam.all.lenght).to eq 3
    end
  end
end
