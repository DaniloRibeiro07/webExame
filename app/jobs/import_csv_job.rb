# frozen_string_literal: true

require 'sidekiq'
require './app/helpers/import_csv_to_bd'

class ImportCsvJob
  include Sidekiq::Job

  def perform(file_code)
    csv_data = File.open "./tmp/#{file_code}.csv"
    ImportCsvToBd.import_csv csv_data.read
    File.delete "./tmp/#{file_code}.csv"
  end
end
