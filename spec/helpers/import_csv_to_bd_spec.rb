require './app/helpers/import_csv_to_bd'

describe '#import_csv' do
  it 'import all patients, exams, doctors, exam results with sucess' do
    csv_data = File.open './spec/support/exam_data.csv'
    result = ImportCsvToBd.import_csv csv_data.read

    expect(result).to eq 'Sucess'
    expect(Patient.all.length).to eq 3
    expect(Doctor.all.length).to eq 3
    expect(Exam.all.length).to eq 3
    expect(ExamResult.all.length).to eq 3
  end
end