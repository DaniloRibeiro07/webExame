# frozen_string_literal: true

require './app/models/exam'

describe Exam do
  describe '#self.create' do
    it 'with sucess' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

      described_class.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'

      last_exam = described_class.all.last

      expect(last_exam.patient_id).to eq patient.id
      expect(last_exam.doctor_id).to eq doctor.id
      expect(last_exam.token).to eq '95954A'
      expect(last_exam.date).to eq '2021-03-05'
      expect(last_exam.id).not_to be_nil
    end

    context 'when it fails because of' do
      it 'miss patient id' do
        doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

        result = described_class.create patient_id: nil, doctor_id: doctor.id, token: '95954A', date: '2021-03-05'

        expect(result).to be false
        expect(described_class.all).to eq []
      end

      it 'miss doctor id' do
        patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                 date_of_birth: '2012-05-05', address: 'rua fernando',
                                 city: 'São Paulo', state: 'São Paulo'

        result = described_class.create patient_id: patient.id, doctor_id: nil, token: '95954A', date: '2021-03-05'

        expect(result).to be false
        expect(described_class.all).to eq []
      end

      it 'miss token' do
        patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                 date_of_birth: '2012-05-05', address: 'rua fernando',
                                 city: 'São Paulo', state: 'São Paulo'
        doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

        result = described_class.create patient_id: patient.id, doctor_id: doctor.id, token: nil, date: '2021-03-05'

        expect(result).to be false
        expect(described_class.all).to eq []
      end

      it 'miss date' do
        patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                 date_of_birth: '2012-05-05', address: 'rua fernando',
                                 city: 'São Paulo', state: 'São Paulo'
        doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

        result = described_class.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: nil

        expect(result).to be false
        expect(described_class.all).to eq []
      end

      it 'duplicate token' do
        patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                 date_of_birth: '2012-05-05', address: 'rua fernando',
                                 city: 'São Paulo', state: 'São Paulo'
        doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

        described_class.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2012-05-05'
        result = described_class.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A',
                                        date: '2015-05-05'

        expect(described_class.all.length).to eq 1
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

      described_class.create patient_id: patient.id, doctor_id: doctor.id, token: '95954A', date: '2012-05-05'

      result = described_class.found_or_create_exam(token: '95954A')

      expect(result.id).not_to eq []
      expect(result.date).to eq '2012-05-05'
    end

    it 'Crate a Exam' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

      result = described_class.found_or_create_exam patient_id: patient.id, doctor_id: doctor.id, token: '95954A',
                                                    date: '2012-05-05'

      expect(result.id).not_to be_nil
      expect(described_class.all.length).to eq 1
    end

    it "not found and doesn't have enough parameters to create" do
      result = described_class.found_or_create_exam token: '95954A', date: '2012-05-05'

      expect(result).to be false
      expect(described_class.all).to eq []
    end
  end
end
