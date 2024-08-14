require './app/models/patient.rb'

describe Patient do 
  context '#self.create' do
    it 'with sucess' do 
      result = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com', date_of_birth: '2012-05-05',
                              address: 'rua fernando', city: 'São Paulo', state: 'São Paulo'

      last_patient = Patient.all.last

      expect(last_patient.cpf).to eq '015.956.326-12'
      expect(last_patient.name).to eq 'Joao'
      expect(last_patient.email).to eq 'joao@email.com'
      expect(last_patient.date_of_birth).to eq '2012-05-05'
      expect(last_patient.address).to eq 'rua fernando'
      expect(last_patient.city).to eq 'São Paulo'
      expect(last_patient.state).to eq 'São Paulo'
      expect(last_patient.id).not_to eq nil
    end

    context 'failed because' do
      it 'miss cpf' do 
        result = Patient.create cpf: nil, name: 'Joao', email: 'joao@email.com', date_of_birth: '2012-05-05',
                              address: 'rua fernando', city: 'São Paulo', state: 'São Paulo'

        expect(result).to eq false
        expect(Patient.all).to eq []
      end

      it 'miss name' do 
        result = Patient.create cpf: '015.956.326-12', name: nil, email: 'joao@email.com', date_of_birth: '2012-05-05',
                              address: 'rua fernando', city: 'São Paulo', state: 'São Paulo'

        expect(Patient.all).to eq []
        expect(result).to eq false
      end

      it 'miss email' do 
        result = Patient.create cpf: '015.956.326-12', name: 'Joao', email: nil, date_of_birth: '2012-05-05',
                              address: 'rua fernando', city: 'São Paulo', state: 'São Paulo'

        expect(Patient.all).to eq []
        expect(result).to eq false
      end

      it 'miss date of birth' do 
        result = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com', date_of_birth: nil,
                              address: 'rua fernando', city: 'São Paulo', state: 'São Paulo'

        expect(Patient.all).to eq []
        expect(result).to eq false
      end

      it 'miss address' do 
        result = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com', date_of_birth: '2012-05-05',
                              address: nil, city: 'São Paulo', state: 'São Paulo'

        expect(Patient.all).to eq []
        expect(result).to eq false
      end

      it 'miss city' do 
        result = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com', date_of_birth: '2012-05-05',
                              address: 'rua fernando', city: nil, state: 'São Paulo'

        expect(Patient.all).to eq []
        expect(result).to eq false
      end

      it 'miss state' do 
        result = Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com', date_of_birth: '2012-05-05',
                              address: 'rua fernando', city: 'São Paulo', state: nil

        expect(Patient.all).to eq []
        expect(result).to eq false
      end

      it 'duplicate cpf' do 
         Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com', date_of_birth: '2012-05-05',
                              address: 'rua fernando', city: 'São Paulo', state: 'São Paulo'
         result = Patient.create cpf: '015.956.326-12', name: 'Maria', email: 'maria@email.com', date_of_birth: '2014-05-05',
                              address: 'rua antonia', city: 'São Paulo', state: 'São Paulo'

         expect(Patient.all.length).to eq 1
         expect(result).to eq false
      end

      it 'duplicate email' do 
        Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com', date_of_birth: '2012-05-05',
                              address: 'rua fernando', city: 'São Paulo', state: 'São Paulo'
        result = Patient.create cpf: '015.876.326-12', name: 'Maria', email: 'joao@email.com', date_of_birth: '2014-05-05',
                              address: 'rua antonia', city: 'São Paulo', state: 'São Paulo'

        expect(Patient.all.length).to eq 1
        expect(result).to eq false
     end
    end
  end

  context '#self.found_or_create_patient' do 
    it 'Found Patient' do
      Patient.create cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com', date_of_birth: '2012-05-05',
                              address: 'rua fernando', city: 'São Paulo', state: 'São Paulo'

      result = Patient.found_or_create_patient(cpf: '015.956.326-12')

      expect(result.id).not_to eq []
      expect(result.name).to eq 'Joao'
    end

    it 'Crate Patient' do
      result = Patient.found_or_create_patient cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com', date_of_birth: '2012-05-05',
                              address: 'rua fernando', city: 'São Paulo', state: 'São Paulo'

      expect(result.id).not_to eq nil
      expect(Patient.all.length).to eq 1
    end

    it "not found and doesn't have enough parameters to create" do
      result = Patient.found_or_create_patient cpf: '015.956.326-12', name: 'Joao', email: 'joao@email.com'

      expect(result).to eq false
      expect(Patient.all).to eq []
    end
  end
end