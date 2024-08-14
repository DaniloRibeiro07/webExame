# frozen_string_literal: true

require './app/models/doctor'

describe Doctor do
  describe '#self.create' do
    it 'with sucess' do
      described_class.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

      last_doctor = described_class.all.last

      expect(last_doctor.crm).to eq '995'
      expect(last_doctor.crm_state).to eq 'SE'
      expect(last_doctor.name).to eq 'Jorge Silva'
      expect(last_doctor.email).to eq 'jorge@email.com'
      expect(last_doctor.id).not_to be_nil
    end

    context 'when it fails because of' do
      it 'miss crm' do
        result = described_class.create crm: nil, crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

        expect(result).to be false
        expect(described_class.all).to eq []
      end

      it 'miss crm_state' do
        result = described_class.create crm: '995', crm_state: nil, name: 'Jorge Silva', email: 'jorge@email.com'

        expect(result).to be false
        expect(described_class.all).to eq []
      end

      it 'miss name' do
        result = described_class.create crm: '995', crm_state: 'SE', name: nil, email: 'jorge@email.com'

        expect(result).to be false
        expect(described_class.all).to eq []
      end

      it 'miss email' do
        result = described_class.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: nil

        expect(result).to be false
        expect(described_class.all).to eq []
      end

      it 'duplicate CRM' do
        described_class.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
        result = described_class.create crm: '995', crm_state: 'PA', name: 'João', email: 'souza@email.com'

        expect(described_class.all.length).to eq 1
        expect(result).to be false
      end

      it 'duplicate email' do
        described_class.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'
        result = described_class.create crm: '885', crm_state: 'PA', name: 'João', email: 'jorge@email.com'

        expect(described_class.all.length).to eq 1
        expect(result).to be false
      end
    end
  end

  describe '#self.found_or_create_doctor' do
    it 'Found a doctor' do
      described_class.create crm: '995', crm_state: 'SE', name: 'Jorge Silva', email: 'jorge@email.com'

      result = described_class.found_or_create_doctor(crm: '995')

      expect(result.id).not_to eq []
      expect(result.name).to eq 'Jorge Silva'
    end

    it 'Crate a doctor' do
      result = described_class.found_or_create_doctor(crm: '995', crm_state: 'SE', name: 'Jorge Silva',
                                                      email: 'jorge@email.com')

      expect(result.id).not_to be_nil
      expect(described_class.all.length).to eq 1
    end

    it "not found and doesn't have enough parameters to create" do
      result = described_class.found_or_create_doctor(crm: '995', crm_state: 'SE')

      expect(result).to be false
      expect(described_class.all).to eq []
    end
  end
end
