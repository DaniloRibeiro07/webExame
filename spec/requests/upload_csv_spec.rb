# frozen_string_literal: true

describe 'POST /uploadCSV' do
  it 'with sucess' do
    csv_data = File.open('./spec/support/exam_data_simple.csv').read

    file_double = class_double File
    allow(SecureRandom).to receive(:hex).with(10).and_return('fileName')
    allow(File).to receive(:open).and_yield(file_double)
    allow(file_double).to receive(:write)

    spy_import_csv_job = class_spy ImportCsvJob
    stub_const 'ImportCsvJob', spy_import_csv_job

    post '/uploadCSV', csv_data, 'CONTENT_TYPE' => 'text/plain'

    expect(spy_import_csv_job).to have_received(:perform_async).with('fileName')
    expect(File).to have_received(:open).with('./tmp/fileName.csv', 'w')
    expect(file_double).to have_received(:write).with(csv_data)
    expect(last_response.status).to eq 200
  end
end
