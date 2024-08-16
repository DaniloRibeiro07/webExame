# frozen_string_literal: true

describe 'User upload csv data from website' do
  it 'with success' do
    allow(SecureRandom).to receive(:hex).with(10).and_return('fileName')

    spy_import_csv_job = class_spy ImportCsvJob
    stub_const 'ImportCsvJob', spy_import_csv_job

    visit '/'

    click_on 'Importar Exames'
    attach_file('file_csv', './spec/support/exam_data_simple.csv')

    file_double = class_double File
    allow(File).to receive(:open).with('./tmp/fileName.csv', 'w').and_yield(file_double)
    allow(file_double).to receive(:write)

    click_on 'Enviar'

    expect(spy_import_csv_job).to have_received(:perform_async).with('fileName')
    expect(file_double).to have_received(:write)
    expect(page).to have_content 'Upload em processamento...'
    expect(page).to have_content 'Retornando a listagem de todos os exames...'
  end
end
