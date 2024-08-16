# frozen_string_literal: true

describe 'User acess List Exams from root path' do
  it 'and see all exams in system' do
    csv_data = File.open './spec/support/exam_data_simple.csv'
    ImportCsvToBd.import_csv csv_data.read

    visit '/'

    expect(page).to have_content 'Exame: IQCZ17'
    expect(page).to have_content 'Paciente: Emilly Batista Neto'
    expect(page).to have_content 'Médico: Maria Luiza Pires'
    expect(page).to have_content 'Data de realização: 05/08/2021'
    within(:css, "div[id='IQCZ17']") do
      expect(page).to have_button 'Detalhes'
    end
    expect(page).to have_content 'Exame: 0W9I67'
    expect(page).to have_content 'Paciente: Juliana dos Reis Filho'
    expect(page).to have_content 'Médico: Maria Helena Ramalho'
    expect(page).to have_content 'Data de realização: 09/07/2021'
    within(:css, "div[id='0W9I67']") do
      expect(page).to have_button 'Detalhes'
    end
    expect(page).to have_content 'Exame: T9O6AI'
    expect(page).to have_content 'Paciente: Matheus Barroso'
    expect(page).to have_content 'Médico: Sra. Calebe Louzada'
    expect(page).to have_content 'Data de realização: 21/11/2021'
    within(:css, "div[id='T9O6AI']") do
      expect(page).to have_button 'Detalhes'
    end
  end

  it 'and no have exams' do
    visit '/'

    expect(page).to have_content 'Não há exames cadastrados no sistema'
  end

  it 'and acess all list exame' do
    csv_data = File.open './spec/support/exam_data_simple.csv'
    ImportCsvToBd.import_csv csv_data.read

    visit '/'
    click_on 'Listar todos os exames'

    expect(page).to have_content 'Exame: IQCZ17'
  end
end
