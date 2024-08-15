# frozen_string_literal: true

require './app/controllers/application_controller'

describe 'User acess List Exams from root path' do
  it 'and see all exams in system' do
    csv_data = File.open './spec/support/exam_data_simple.csv'
    ImportCsvToBd.import_csv csv_data.read

    visit '/'

    expect(page).to have_content 'Exame: IQCZ17'
    expect(page).to have_content 'Paciente: Emilly Batista Neto'
    expect(page).to have_content 'Médico: Maria Luiza Pires'
    expect(page).to have_content 'Exame: 0W9I67'
    expect(page).to have_content 'Paciente: Juliana dos Reis Filho'
    expect(page).to have_content 'Médico: Maria Helena Ramalho'
    expect(page).to have_content 'Exame: T9O6AI'
    expect(page).to have_content 'Paciente: Matheus Barroso'
    expect(page).to have_content 'Médico: Sra. Calebe Louzada'
  end

  it 'and no have exams' do
    visit '/'
    expect(page).to have_content 'Não há exames cadastrados no sistema'
  end
end
