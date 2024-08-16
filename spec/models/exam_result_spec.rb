# frozen_string_literal: true

describe ExamResult do
  describe '#self.create' do
    it 'with sucess' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
      exam = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'

      ExamResult.create exam_id: exam.id, type: 'ecg', limit_exam: '59-6', result_type: '45'

      last_exam_result = ExamResult.all.last

      expect(last_exam_result.exam_id).to eq exam.id
      expect(last_exam_result.type).to eq 'ecg'
      expect(last_exam_result.limit_exam).to eq '59-6'
      expect(last_exam_result.result_type).to eq '45'
      expect(last_exam_result.id).not_to be_nil
    end

    context 'when it fails because of' do
      it 'miss exam id' do
        result = ExamResult.create exam_id: nil, type: 'ecg', limit_exam: '59-6', result_type: '45'

        expect(result).to be false
        expect(ExamResult.all).to eq []
      end

      it 'miss type' do
        patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                 date_of_birth: '2012-05-05', address: 'rua fernando',
                                 city: 'São Paulo', state: 'São Paulo'
        doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
        exam = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'

        result = ExamResult.create exam_id: exam.id, type: nil, limit_exam: '59-6', result_type: '45'

        expect(result).to be false
        expect(ExamResult.all).to eq []
      end

      it 'miss limit_exam' do
        patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                 date_of_birth: '2012-05-05', address: 'rua fernando',
                                 city: 'São Paulo', state: 'São Paulo'
        doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
        exam = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'

        result = ExamResult.create exam_id: exam.id, type: 'ECG', limit_exam: nil, result_type: '45'

        expect(result).to be false
        expect(ExamResult.all).to eq []
      end

      it 'miss result_type' do
        patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                 date_of_birth: '2012-05-05', address: 'rua fernando',
                                 city: 'São Paulo', state: 'São Paulo'
        doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
        exam = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'

        result = ExamResult.create exam_id: exam.id, type: 'ECG', limit_exam: '95-96', result_type: nil

        expect(result).to be false
        expect(ExamResult.all).to eq []
      end
    end
  end

  describe '#to_json' do
    it 'convert all exam result params to json' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
      exam = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'
      exam_result = ExamResult.create exam_id: exam.id, type: 'ecg', limit_exam: '59-6', result_type: '45'

      json = { id: exam_result.id, exam_id: exam.id, type: 'ecg', limit_exam: '59-6', result_type: '45' }.to_json

      expect(exam_result.to_json).to eq json
    end
  end
end
