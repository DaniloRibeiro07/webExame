# frozen_string_literal: true

describe 'user see exam details' do
  it 'from click in card details exams' do
    csv_data = File.open './spec/support/exam_data_simple.csv'
    ImportCsvToBd.import_csv csv_data.read

    visit '/'

    within(:css, "div[id='0W9I67']") do
      click_on 'Detalhes'
    end

    within(:css, "div[id='patient']") do
      expect(page).to have_content 'Nome completo: Juliana dos Reis Filho'
      expect(page).to have_content 'Email: mariana_crist@kutch-torp.com'
      expect(page).to have_content 'Data de nascimento: 03/07/1995'
      expect(page).to have_content 'Cidade/Estado: Lagoa da Canoa/Paraíba'
    end

    within(:css, "div[id='doctor']") do
      expect(page).to have_content 'Nome completo: Maria Helena Ramalho'
      expect(page).to have_content 'Email: rayford@kemmer-kunze.info'
      expect(page).to have_content 'CRM: B0002IQM66 - SC'
    end
    expect(page).to have_content 'Token: 0W9I67'
    expect(page).to have_content 'Data de realização: 09/07/2021'
    expect(page).to have_content 'leucócitos'
    expect(page).to have_content '91'
    expect(page).to have_content '9-61'
  end

  it 'from search input and click button' do
    csv_data = File.open './spec/support/exam_data_simple.csv'
    ImportCsvToBd.import_csv csv_data.read

    visit '/'

    find('#search_input').set '0W9I67'

    click_on 'Buscar'

    expect(page).to have_content 'Nome completo: Juliana dos Reis Filho'
    expect(page).to have_content 'CRM: B0002IQM66 - SC'
    expect(page).to have_content 'Token: 0W9I67'
    expect(page).to have_content 'Data de realização: 09/07/2021'
    expect(page).to have_content 'leucócitos'
  end

  it 'from inexistente token' do
    visit '/'

    find('#search_input').set '0W9I67'

    click_on 'Buscar'

    expect(page).to have_content 'Exame com o Token 0W9I67 não encontrado'
  end
end
