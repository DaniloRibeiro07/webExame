# frozen_string_literal: true

require './app/models/exam'

describe Exam do
  describe '#self.create' do
    it 'with sucess' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

      Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'

      last_exam = Exam.all.last

      expect(last_exam.patient_id).to eq patient.id
      expect(last_exam.doctor_id).to eq doctor.id
      expect(last_exam.token).to eq '95954A'
      expect(last_exam.date).to eq '2021-03-05'
      expect(last_exam.id).not_to be_nil
    end

    context 'when it fails because of' do
      it 'miss patient id' do
        doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

        result = Exam.create patient_id: nil, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'

        expect(result).to be false
        expect(Exam.all).to eq []
      end

      it 'miss doctor id' do
        patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                 date_of_birth: '2012-05-05', address: 'rua fernando',
                                 city: 'São Paulo', state: 'São Paulo'

        result = Exam.create patient_id: patient.id, doctor_id: nil, token: '95954A', date: '2021-03-05'

        expect(result).to be false
        expect(Exam.all).to eq []
      end

      it 'miss token' do
        patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                 date_of_birth: '2012-05-05', address: 'rua fernando',
                                 city: 'São Paulo', state: 'São Paulo'
        doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

        result = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: nil, date: '2021-03-05'

        expect(result).to be false
        expect(Exam.all).to eq []
      end

      it 'miss date' do
        patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                 date_of_birth: '2012-05-05', address: 'rua fernando',
                                 city: 'São Paulo', state: 'São Paulo'
        doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

        result = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: nil

        expect(result).to be false
        expect(Exam.all).to eq []
      end

      it 'duplicate token' do
        patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                 date_of_birth: '2012-05-05', address: 'rua fernando',
                                 city: 'São Paulo', state: 'São Paulo'
        doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

        Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2012-05-05'
        result = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A',
                             date: '2015-05-05'

        expect(Exam.all.length).to eq 1
        expect(result).to be false
      end
    end
  end

  describe '#self.found_or_create_Exam' do
    it 'Found a Exam' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

      Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2012-05-05'

      result = Exam.found_or_create_exam(token: '95954A')

      expect(result.id).not_to eq []
      expect(result.date).to eq '2012-05-05'
    end

    it 'Crate a Exam' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

      result = Exam.found_or_create_exam patient_id: patient.id, doctor_id: doctor.id, token: '95954A',
                                         date: '2012-05-05'

      expect(result.id).not_to be_nil
      expect(Exam.all.length).to eq 1
    end

    it "not found and doesn't have enough parameters to create" do
      result = Exam.found_or_create_exam token: '95954A', date: '2012-05-05'

      expect(result).to be false
      expect(Exam.all).to eq []
    end
  end

  describe '#to_json' do
    it 'convert all exam params to json' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
      exam = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'

      json = { id: exam.id, patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05' }.to_json

      expect(exam.to_json).to eq json
    end

    it 'convert all exam params to json and include patient and doctor relations and remove id from patient and exam' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
      exam = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'

      json = { patient: {cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com', date_of_birth: '2012-05-05',
                        address: 'rua fernando',city: 'São Paulo', state: 'São Paulo'},
              doctor: {id: doctor.id, crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'},
              token: '95954A', date: '2021-03-05' }.to_json

      expect(exam.to_json(relations:{patient: {excepts: ["id"]}, doctor: nil}, excepts: ["id"])).to eq json
    end

    it 'convert all exam params to json and include all exame result params, except id from relation' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
      exam = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'
      exam_result = ExamResult.create exam_id: exam.id, type: 'ecg', limit_exam: '59-6', result_type: '45'
      exam_result = ExamResult.create exam_id: exam.id, type: 'emg', limit_exam: '60-8', result_type: '12'
      exam_result = ExamResult.create exam_id: exam.id, type: 'cadio', limit_exam: '45-9', result_type: '50'

      json = {id: exam.id, patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05', 
              exam_result: [ {type: 'ecg', limit_exam: '59-6', result_type: '45'},
                             {type: 'emg', limit_exam: '60-8', result_type: '12'},
                             {type: 'cadio', limit_exam: '45-9', result_type: '50'},
              ]}.to_json

      expect(exam.to_json(relations:{exam_result: {excepts: ["id"]}})).to eq json
    end
  end
end
