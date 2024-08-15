# frozen_string_literal: true

require './app/controllers/application_controller'

describe 'GET /exam/:token' do
  context 'with sucess' do
    it 'has exam' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
      exam = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'
      ExamResult.create exam_id: exam.id, type: 'ecg', limit_exam: '59-6', result_type: '45'
      ExamResult.create exam_id: exam.id, type: 'cadio', limit_exam: '45-9', result_type: '50'

      json = { patient: { cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com', date_of_birth: '2012-05-05',
                          address: 'rua fernando', city: 'São Paulo', state: 'São Paulo' },
               doctor: { crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com' },
               token: '95954A', date: '2021-03-05',
               exam_result: [
                 { type: 'ecg', limit_exam: '59-6', result_type: '45' },
                 { type: 'cadio', limit_exam: '45-9', result_type: '50' }
               ] }.to_json

      get '/exam/95954A'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq json
    end

    it 'not found exam' do
      get '/exam/95954A'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq '{}'
    end
  end
end
