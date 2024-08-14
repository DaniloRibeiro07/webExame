# frozen_string_literal: true

require_relative 'application_model'

class ExamResult < ApplicationModel
  attr_accessor :id, :exam_id, :type, :limit_exam, :result_type

  TABLE_NAME = 'exam_results'

  SQL = <<-SQL_CMD.gsub(/\s+/, ' ').strip
      CREATE TABLE exam_results (
        id SERIAL NOT NULL UNIQUE,
        exam_id INT NOT NULL,
        type VARCHAR NOT NULL,
        limit_exam VARCHAR NOT NULL,
        result_type INT NOT NULL,
        PRIMARY KEY (ID),
        FOREIGN KEY (exam_id) REFERENCES exams(id)
      );
  SQL_CMD

  def self.create(exam_id: nil, type: nil, limit_exam: nil, result_type: nil)
    result = super(exam_id:, type:, limit_exam:, result_type:)
    return find(exam_id:, type:, limit_exam:, result_type:)[0] if result.instance_of?(PG::Result)

    false
  end
end
