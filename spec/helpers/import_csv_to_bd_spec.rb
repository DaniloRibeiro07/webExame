# frozen_string_literal: true

require './app/helpers/import_csv_to_bd'

describe ImportCsvToBd do
  describe '#self.import_csv' do
    it 'sucess' do
      csv_data = File.open './spec/support/exam_data_simple.csv'
      result = ImportCsvToBd.import_csv csv_data.read

      expect(result).to eq 'finish'
      expect(Patient.all.length).to eq 3
      expect(Doctor.all.length).to eq 3
      expect(Exam.all.length).to eq 3
      expect(ExamResult.all.length).to eq 3
    end

    it 'ignore line with inconsistent parameters' do
      csv_data = File.open './spec/support/exam_data_line_error.csv'
      result = ImportCsvToBd.import_csv csv_data.read

      expect(result).to eq 'finish'
      expect(Patient.all.length).to eq 3
      expect(Doctor.all.length).to eq 3
      expect(Exam.all.length).to eq 3
      expect(ExamResult.all.length).to eq 3
    end

    it 'partial import' do
      csv_data = File.open './spec/support/exam_data_partial.csv'
      result = ImportCsvToBd.import_csv csv_data.read

      expect(result).to eq 'finish'
      expect(Patient.all.length).to eq 3
      expect(Doctor.all.length).to eq 2
      expect(Exam.all.length).to eq 1
      expect(ExamResult.all.length).to eq 1
    end

    it 'and not duplicate patients, exams and doctors records' do
      csv_data = File.open './spec/support/exam_data_complex.csv'
      result = ImportCsvToBd.import_csv csv_data.read

      expect(result).to eq 'finish'
      expect(Patient.all.length).to eq 3
      expect(Doctor.all.length).to eq 3
      expect(Exam.all.length).to eq 4
      expect(ExamResult.all.length).to eq 19
    end
  end
end
