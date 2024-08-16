# frozen_string_literal: true

require 'pg'
require './app/models/application_model'
require './app/models/patient'
require './app/models/doctor'
require './app/models/exam_result'
require './app/models/exam'

class Db
  MODELS = [Patient, Doctor, Exam, ExamResult].freeze

  def self.name
    return 'test' if ENV['TEST'] == 'true'

    'db'
  end

  def self.init_models
    create_database unless check_if_db_create

    begin
      pgdb = PG.connect host: 'PGExame', user: 'admin', password: 'admin', dbname: name

      MODELS.each do |model|
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
      table_names = MODELS.map { |model| model::TABLE_NAME }
      pgdb.exec "TRUNCATE #{table_names.join(', ')} RESTART IDENTITY;"
    rescue StandardError => e
      puts e
    end
    pgdb.close
  end

  def self.reset
    begin
      drop_database
      create_database
    rescue StandardError => e
      puts e
      create_database
    end
    init_models
  end

  private_class_method def self.drop_database
    pgdb = PG.connect host: 'PGExame', user: 'admin', password: 'admin', dbname: 'postgres'
    pgdb.exec "DROP DATABASE #{name}"
    pgdb.close
  end

  private_class_method def self.create_database
    pgdb = PG.connect host: 'PGExame', user: 'admin', password: 'admin', dbname: 'postgres'
    pgdb.exec "CREATE DATABASE #{name}"
    pgdb.close
  end

  private_class_method def self.create_model_in_db(pgdb, model)
    return if model.in_bd?

    pgdb.exec model::SQL
  end

  private_class_method def self.check_if_db_create
    pgdb = PG.connect host: 'PGExame', user: 'admin', password: 'admin', dbname: 'postgres'
    sql = "select exists(SELECT datname FROM pg_catalog.pg_database WHERE lower(datname) = lower('#{name}'));"
    db_exist = pgdb.exec sql
    pgdb.close
    db_exist.to_a[0]['exists'] == 't'
  end
end
