# frozen_string_literal: true

describe ImportCsvJob do
  it '#perfom' do
    csv_data = File.open './spec/support/exam_data_simple.csv'

    allow(File).to receive(:open).with('./tmp/teste.csv').and_return(csv_data)
    allow(File).to receive(:delete).with('./tmp/teste.csv')
    ImportCsvJob.perform_inline 'teste'

    expect(File).to have_received(:delete).with('./tmp/teste.csv')
    expect(Patient.all.length).to eq 3
    expect(Doctor.all.length).to eq 3
    expect(Exam.all.length).to eq 3
    expect(ExamResult.all.length).to eq 3
  end
end
