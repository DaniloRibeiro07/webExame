require './app/models/doctor.rb'

describe Doctor do 
  context '#create' do
    it 'with sucess' do 
      result = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

      last_doctor = Doctor.all.last

      expect(last_doctor.crm).to eq '995'
      expect(last_doctor.crm_state).to eq 'SE'
      expect(last_doctor.name).to eq 'Jorge Silva'
      expect(last_doctor.email).to eq 'jorge@email.com'
      expect(last_doctor.id).not_to eq nil
    end

    context 'failed because' do
      it 'miss crm' do 
        result = Doctor.create crm: nil, crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

        expect(Doctor.all).to eq []
      end

      it 'miss crm_state' do 
        result = Doctor.create crm: '995', crm_state: nil, name: 'Jorge Silva', email: 'jorge@email.com'

        expect(Doctor.all).to eq []
      end

      it 'miss name' do 
        result = Doctor.create crm: '995', crm_state: "SE", name: nil, email: 'jorge@email.com'

        expect(Doctor.all).to eq []
      end

      it 'miss email' do 
        result = Doctor.create crm: '995', crm_state: "SE", name: 'Jorge Silva', email: nil

        expect(Doctor.all).to eq []
      end

      it 'duplicate CRM' do 
         Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
         result = Doctor.create crm: '995', crm_state: 'PA', name: 'João', email: 'souza@email.com'

         expect(Doctor.all.length).to eq 1
         expect(result).to eq false
      end

      it 'duplicate email' do 
        Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
        result = Doctor.create crm: '885', crm_state: 'PA', name: 'João', email: 'jorge@email.com'

        expect(Doctor.all.length).to eq 1
        expect(result).to eq false
     end
    end
  end

  context '#found_or_create_doctor' do 
    it 'Found a doctor' do
      Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

      result = Doctor.found_or_create_doctor(crm: '995')

      expect(result.id).not_to eq []
      expect(result.name).to eq 'Jorge Silva'
    end

    it 'Crate a doctor' do
      result = Doctor.found_or_create_doctor(crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com')

      expect(result.id).not_to eq nil
      expect(Doctor.all.length).to eq 1
    end

    it "not found and doesn't have enough parameters to create" do
      result = Doctor.found_or_create_doctor(crm: '995', crm_state: 'SE')

      expect(result).to eq false
      expect(Doctor.all).to eq []
    end

  end
end