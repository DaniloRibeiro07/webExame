# frozen_string_literal: true

describe Patient do
  describe '#self.create' do
    it 'with sucess' do
      Patient.create cpf: '015.956.326-12', email: 'joao@email.com', date_of_birth: '2012-05-05',
                     address: 'rua fernando', city: 'São Paulo', state: 'São Paulo', name: 'Joao'

      last_patient = Patient.all.last

      expect(last_patient.cpf).to eq '015.956.326-12'
      expect(last_patient.name).to eq 'Joao'
      expect(last_patient.email).to eq 'joao@email.com'
      expect(last_patient.date_of_birth).to eq '2012-05-05'
      expect(last_patient.address).to eq 'rua fernando'
      expect(last_patient.city).to eq 'São Paulo'
      expect(last_patient.state).to eq 'São Paulo'
      expect(last_patient.id).not_to be_nil
    end

    context 'when it fails because of' do
      it 'miss cpf' do
        result = Patient.create cpf: nil, email: 'joao@email.com', date_of_birth: '2012-05-05',
                                address: 'rua fernando', city: 'São Paulo', state: 'São Paulo', name: 'Joao'

        expect(result).to be false
        expect(Patient.all).to eq []
      end

      it 'miss name' do
        result = Patient.create cpf: '015.956.326-12', email: 'joao@email.com', date_of_birth: '2012-05-05',
                                address: 'rua fernando', city: 'São Paulo', state: 'São Paulo', name: nil

        expect(Patient.all).to eq []
        expect(result).to be false
      end

      it 'miss email' do
        result = Patient.create cpf: '015.956.326-12', name: 'Joao', email: nil, date_of_birth: '2012-05-05',
                                address: 'rua fernando', city: 'São Paulo', state: 'São Paulo'

        expect(Patient.all).to eq []
        expect(result).to be false
      end

      it 'miss date of birth' do
        result = Patient.create cpf: '015.956.326-12', email: 'joao@email.com', date_of_birth: nil,
                                address: 'rua fernando', city: 'São Paulo', state: 'São Paulo', name: 'Joao'

        expect(Patient.all).to eq []
        expect(result).to be false
      end

      it 'miss address' do
        result = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                address: nil, city: 'São Paulo', state: 'São Paulo', date_of_birth: '2012-05-05'

        expect(Patient.all).to eq []
        expect(result).to be false
      end

      it 'miss city' do
        result = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                address: 'rua fernando', city: nil,
                                state: 'São Paulo', date_of_birth: '2012-05-05'

        expect(Patient.all).to eq []
        expect(result).to be false
      end

      it 'miss state' do
        result = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                                address: 'rua fernando', city: 'São Paulo',
                                state: nil, date_of_birth: '2012-05-05'

        expect(Patient.all).to eq []
        expect(result).to be false
      end

      it 'duplicate cpf' do
        Patient.create cpf: '015.956.326-12', email: 'joao@email.com', date_of_birth: '2012-05-05',
                       address: 'rua fernando', city: 'São Paulo', state: 'São Paulo', name: 'Joao'

        result = Patient.create cpf: '015.956.326-12', name: 'Maria', email: 'maria@email.com',
                                date_of_birth: '2014-05-05', state: 'São Paulo',
                                address: 'rua antonia', city: 'São Paulo'

        expect(Patient.all.length).to eq 1
        expect(result).to be false
      end

      it 'duplicate email' do
        Patient.create cpf: '015.956.326-12', email: 'joao@email.com', date_of_birth: '2012-05-05',
                       address: 'rua fernando', city: 'São Paulo', state: 'São Paulo', name: 'Joao'
        result = Patient.create cpf: '015.876.326-12', name: 'Maria', email: 'joao@email.com',
                                date_of_birth: '2014-05-05', state: 'São Paulo',
                                address: 'rua antonia', city: 'São Paulo'

        expect(Patient.all.length).to eq 1
        expect(result).to be false
      end
    end
  end

  describe '#self.found_or_create_patient' do
    it 'Found Patient' do
      Patient.create cpf: '015.956.326-12', email: 'joao@email.com', date_of_birth: '2012-05-05',
                     address: 'rua fernando', city: 'São Paulo', state: 'São Paulo', name: 'Joao'

      result = Patient.found_or_create_patient(cpf: '015.956.326-12')

      expect(result.id).not_to eq []
      expect(result.name).to eq 'Joao'
    end

    it 'Crate Patient' do
      result = Patient.found_or_create_patient cpf: '015.956.326-12', email: 'joao@email.com',
                                               date_of_birth: '2012-05-05',
                                               address: 'rua fernando', city: 'São Paulo',
                                               state: 'São Paulo', name: 'Joao'

      expect(result.id).not_to be_nil
      expect(Patient.all.length).to eq 1
    end

    it "not found and doesn't have enough parameters to create" do
      result = Patient.found_or_create_patient cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com'

      expect(result).to be false
      expect(Patient.all).to eq []
    end
  end

  describe '#to_json' do
    it 'convert all patient params to json' do
      patient = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
                               date_of_birth: '2012-05-05', address: 'rua fernando',
                               city: 'São Paulo', state: 'São Paulo'

      json = { id: patient.id, cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com',
               date_of_birth: '2012-05-05', address: 'rua fernando',
               city: 'São Paulo', state: 'São Paulo' }.to_json

      expect(patient.to_json).to eq json
    end
  end
end
