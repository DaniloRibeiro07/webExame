# frozen_string_literal: true

require 'pg'
require './app/models/application_model'
require './app/models/doctor'
require './app/models/exam_result'
require './app/models/exam'
require './app/models/patient'

class Db
  MODELS = [Patient, Doctor, Exam, ExamResult].freeze

  def self.init_models
    begin
      pgdb = PG.connect host: 'PGExame', user: 'admin', password: 'admin', dbname: 'db'

      MODELS.each do |model|
        next if model.created?

        create_model_in_db(pgdb, model)
      end
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
    end
    pgdb.close
    init_models
  end

  private_class_method def self.drop_database(pgdb)
    pgdb.exec 'DROP DATABASE db'
    puts 'Database db deletado'
  end

  private_class_method def self.create_database(pgdb)
    pgdb.exec 'CREATE DATABASE db'
    puts 'Database db criado'
  end

  private_class_method def self.create_model_in_db(pgdb, model)
    pgdb.exec model::SQL
    puts "Model: #{model.name} criado!"
  end
end
