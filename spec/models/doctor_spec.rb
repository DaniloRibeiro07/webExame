# frozen_string_literal: true

require './app/models/doctor'

describe Doctor do
  describe '#self.create' do
    it 'with sucess' do
      Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

      last_doctor = Doctor.all.last

      expect(last_doctor.crm).to eq '995'
      expect(last_doctor.crm_state).to eq 'SE'
      expect(last_doctor.name).to eq 'Jorge Silva'
      expect(last_doctor.email).to eq 'jorge@email.com'
      expect(last_doctor.id).not_to be_nil
    end

    context 'when it fails because of' do
      it 'miss crm' do
        result = Doctor.create crm: nil, crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

        expect(result).to be false
        expect(Doctor.all).to eq []
      end

      it 'miss crm_state' do
        result = Doctor.create crm: '995', crm_state: nil, name: 'Jorge Silva', email: 'jorge@email.com'

        expect(result).to be false
        expect(Doctor.all).to eq []
      end

      it 'miss name' do
        result = Doctor.create crm: '995', crm_state: 'SE', name: nil, email: 'jorge@email.com'

        expect(result).to be false
        expect(Doctor.all).to eq []
      end

      it 'miss email' do
        result = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: nil

        expect(result).to be false
        expect(Doctor.all).to eq []
      end

      it 'duplicate CRM' do
        Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
        result = Doctor.create crm: '995', crm_state: 'PA', name: 'João', email: 'souza@email.com'

        expect(Doctor.all.length).to eq 1
        expect(result).to be false
      end

      it 'duplicate email' do
        Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
        result = Doctor.create crm: '885', crm_state: 'PA', name: 'João', email: 'jorge@email.com'

        expect(Doctor.all.length).to eq 1
        expect(result).to be false
      end
    end
  end

  describe '#self.found_or_create_doctor' do
    it 'Found a doctor' do
      Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

      result = Doctor.found_or_create_doctor(crm: '995')

      expect(result.id).not_to eq []
      expect(result.name).to eq 'Jorge Silva'
    end

    it 'Crate a doctor' do
      result = Doctor.found_or_create_doctor(crm: '995', crm_state: 'SE', name: 'Jorge Silva',
                                             email: 'jorge@email.com')

      expect(result.id).not_to be_nil
      expect(Doctor.all.length).to eq 1
    end

    it "not found and doesn't have enough parameters to create" do
      result = Doctor.found_or_create_doctor(crm: '995', crm_state: 'SE')

      expect(result).to be false
      expect(Doctor.all).to eq []
    end
  end

  describe '#to_json' do
    it 'convert all doctor params to json' do
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
      json = { id: doctor.id, crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com' }.to_json

      expect(doctor.to_json).to eq json
    end
    
    it 'convert all doctor params to json except id' do
      doctor = Doctor.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
      json = {crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com' }.to_json

      expect(doctor.to_json(excepts: ['id'])).to eq json
    end
  end
end
