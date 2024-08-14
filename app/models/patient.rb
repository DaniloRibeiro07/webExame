# frozen_string_literal: true

require_relative 'application_model'

class Patient < ApplicationModel
  attr_accessor :id, :cpf, :name, :email, :date_of_birth, :address, :city, :state

  TABLE_NAME = 'patients'

  SQL = <<-SQL_CMD.gsub(/\s+/, ' ').strip
      CREATE TABLE patients (
        id SERIAL NOT NULL UNIQUE,
        cpf CHAR(14) NOT NULL UNIQUE,
        name VARCHAR NOT NULL,
        email VARCHAR NOT NULL UNIQUE,
        date_of_birth DATE NOT NULL,
        address VARCHAR NOT NULL,
        city VARCHAR NOT NULL,
        state VARCHAR NOT NULL,
        PRIMARY KEY (ID)
      );
  SQL_CMD

  def self.create(*params)
    params = params[0]

    result = super cpf: params[:cpf], name: params[:name], email: params[:email],
                   date_of_birth: params[:date_of_birth], address: params[:address],
                   city: params[:city], state: params[:state]
    return find(cpf: params[:cpf])[0] if result.instance_of?(PG::Result)

    false
  end

  def self.found_or_create_patient(*params)
    params = params[0]

    patient = find cpf: params[:cpf]
    return patient[0] if patient

    create cpf: params[:cpf], name: params[:name], email: params[:email],
           date_of_birth: params[:date_of_birth], address: params[:address],
           city: params[:city], state: params[:state]
  end
end
