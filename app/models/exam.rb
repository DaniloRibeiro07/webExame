# frozen_string_literal: true

require_relative 'application_model'

class Exam < ApplicationModel
  attr_accessor :id, :patient_id, :doctor_id, :token, :date

  TABLE_NAME = 'exams'

  SQL = <<-SQL_CMD.gsub(/\s+/, ' ').strip
      CREATE TABLE exams(
        id SERIAL NOT NULL UNIQUE,
        patient_id INT NOT NULL,
        doctor_id INT NOT NULL,
        token VARCHAR NOT NULL UNIQUE,
        date DATE NOT NULL,
        PRIMARY KEY (ID),
        FOREIGN KEY (patient_id) REFERENCES patients(id),
        FOREIGN KEY (doctor_id) REFERENCES doctors(id)
      );
  SQL_CMD

  def self.create(patient_id: nil, doctor_id: nil, token: nil, date: nil)
    result = super(patient_id:, doctor_id:, token:, date:)
    return find(patient_id:, doctor_id:, token:, date:)[0] if result.instance_of?(PG::Result)

    false
  end

  def self.found_or_create_exam(patient_id: nil, doctor_id: nil, token: nil, date: nil)
    exam = find(token:)
    return exam[0] if exam

    create patient_id:, doctor_id:, token:, date:
  end
end
