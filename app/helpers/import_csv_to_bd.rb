# frozen_string_literal: true

require './db/db'

class ImportCsvToBd
  def self.import_csv(file)
    data = file.split "\n"

    data.each do |exam_data|
      register_all_component exam_data.split ';'
    end

    'finish'
  end

  private_class_method def self.register_all_component(exam_data)
    patient = select_patient exam_data
    return unless patient

    doctor = select_doctor exam_data
    return unless doctor

    exam = select_exam exam_data, patient, doctor
    return unless exam

    result_exam = ExamResult.create exam_id: exam.id, type: exam_data[13],
                                    limit_exam: exam_data[14], result_type: exam_data[15]

    return if result_exam
  end

  private_class_method def self.select_patient(exam_data)
    patient = Patient.found_or_create_patient cpf: exam_data[0], name: exam_data[1], email: exam_data[2],
                                              date_of_birth: exam_data[3], address: exam_data[4],
                                              city: exam_data[5], state: exam_data[6]
    return patient if patient

    false
  end

  private_class_method def self.select_doctor(exam_data)
    doctor = Doctor.found_or_create_doctor crm: exam_data[7], crm_state: exam_data[8],
                                           name: exam_data[9], email: exam_data[10]

    return doctor if doctor

    false
  end

  private_class_method def self.select_exam(exam_data, patient, doctor)
    exam = Exam.found_or_create_exam token: exam_data[11], date: exam_data[12],
                                     patient_id: patient.id, doctor_id: doctor.id

    return exam if exam

    false
  end
end
