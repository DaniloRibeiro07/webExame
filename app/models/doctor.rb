# frozen_string_literal: true

require_relative 'application_model'

class Doctor < ApplicationModel
  attr_accessor :id, :crm, :crm_state, :name, :email

  TABLE_NAME = 'doctors'

  SQL = <<-SQL_CMD.gsub(/\s+/, ' ').strip
      CREATE TABLE doctors (
        id SERIAL NOT NULL UNIQUE,
        crm VARCHAR NOT NULL UNIQUE,
        crm_state CHAR(2) NOT NULL,
        name VARCHAR NOT NULL,
        email VARCHAR NOT NULL UNIQUE,
        PRIMARY KEY (ID)
      );
  SQL_CMD

  def self.create(crm: nil, crm_state: nil, name: nil, email: nil)
    result = super(crm:, crm_state:, name:, email:)
    return find(crm:)[0] if result.instance_of?(PG::Result)

    false
  end

  def self.found_or_create_doctor(crm: nil, crm_state: nil, name: nil, email: nil)
    doctor = find(crm:)
    return doctor[0] if doctor

    create crm:, crm_state:, name:, email:
  end
end
