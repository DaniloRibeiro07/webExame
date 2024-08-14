# frozen_string_literal: true

require 'pg'
require './app/models/application_model'
require './app/models/doctor'
require './app/models/exam_result'
require './app/models/exam'
require './app/models/patient'

class Db
  MODELS = [Patient, Doctor, Exam, ExamResult].freeze

  def self.name
    return 'test' if ENV['TEST'] == 'true'

    'db'
  end

  def self.init_models
    begin
      pgdb = PG.connect host: 'PGExame', user: 'admin', password: 'admin', dbname: name

      MODELS.each do |model|
        next if model.created?

        create_model_in_db(pgdb, model)
      end
    rescue StandardError => e
      puts e
    end
    pgdb.close
  end

  def self.truncate
    begin
      pgdb = PG.connect host: 'PGExame', user: 'admin', password: 'admin', dbname: name
      table_names = MODELS.map{|model| model::TABLE_NAME}
      pgdb.exec "TRUNCATE #{table_names.join(', ')} RESTART IDENTITY;"
    rescue StandardError => e
      puts e
    end
    pgdb.close
  end

  def self.reset
    begin
      pgdb = PG.connect host: 'PGExame', user: 'admin', password: 'admin', dbname: 'postgres'
      drop_database(pgdb)
      create_database(pgdb)
    rescue StandardError => e
      puts e
      create_database(pgdb)
    end
    pgdb.close
    init_models
  end

  private_class_method def self.drop_database(pgdb)
    pgdb.exec "DROP DATABASE #{name}"
  end

  private_class_method def self.create_database(pgdb)
    pgdb.exec "CREATE DATABASE #{name}"
  end

  private_class_method def self.create_model_in_db(pgdb, model)
    pgdb.exec model::SQL
  end
end
