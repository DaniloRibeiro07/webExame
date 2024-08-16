require './app/controllers/application_controller'

csv_data = File.open './db/data.csv'
ImportCsvToBd.import_csv csv_data.read
puts 'Base de dados populada'