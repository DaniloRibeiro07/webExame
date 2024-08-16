# frozen_string_literal: true

describe Db do
  describe '#self.name' do
    it 'in environment test' do
      expect(Db.name).to eq 'test'
    end

    it 'in not environment test' do
      ENV['TEST'] = nil
      expect(Db.name).to eq 'db'
      ENV['TEST'] = 'true'
    end
  end

  describe '#self.init_models' do
    it 'initialize all models in db' do
      pgdb = PG.connect host: 'PGExame', user: 'admin', password: 'admin', dbname: Db.name
      pgdb.exec 'DROP TABLE exam_results'
      pgdb.close

      expect(ExamResult.in_bd?).to be false
      Db.init_models
      expect(ExamResult.in_bd?).to be true
    end
  end

  describe '#self.truncate' do
    it 'Reset all table' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
      exam = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'
      ExamResult.create exam_id: exam.id, type: 'ecg', limit_exam: '59-6', result_type: '45'

      Db.truncate

      expect(ExamResult.all.empty?).to be true
      expect(Exam.all.empty?).to be true
      expect(Doctor.all.empty?).to be true
      expect(Patient.all.empty?).to be true
    end
  end

  describe '#self.reset' do
    it 'Reset DB and init models' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
      exam = Exam.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'
      ExamResult.create exam_id: exam.id, type: 'ecg', limit_exam: '59-6', result_type: '45'

      Db.reset

      expect(ExamResult.all.empty?).to be true
      expect(ExamResult.in_bd?).to be true
      expect(Exam.all.empty?).to be true
      expect(Exam.in_bd?).to be true
      expect(Doctor.all.empty?).to be true
      expect(Doctor.in_bd?).to be true
      expect(Patient.all.empty?).to be true
      expect(Patient.in_bd?).to be true
    end
  end
end
