require 'spec_helper'

module Plutus
  describe Account do
    describe 'tenancy support' do
      before(:each) do
        ActiveSupportHelpers.clear_model('Account')
        ActiveSupportHelpers.clear_model('Asset')

        Plutus.enable_tenancy = true
        Plutus.tenant_class = 'Plutus::Entry'

        FactoryBotHelpers.reload()
        Plutus::Asset.new
      end

      after(:each) do
        if Plutus.const_defined?(:Asset)
          ActiveSupportHelpers.clear_model('Account')
          ActiveSupportHelpers.clear_model('Asset')
        end

        Plutus.enable_tenancy = false
        Plutus.tenant_class = nil

        FactoryBotHelpers.reload()
      end

      it 'validate uniqueness of name scoped to tenant' do
        account = FactoryBot.create(:asset, tenant_id: 10)

        record = FactoryBot.build(:asset, name: account.name, tenant_id: 10)
        expect(record).not_to be_valid
        expect(record.errors[:name]).to eq(['has already been taken'])
      end

      it 'allows same name scoped under a different tenant' do
        account = FactoryBot.create(:asset, tenant_id: 10)

        record = FactoryBot.build(:asset, name: account.name, tenant_id: 11)
        expect(record).to be_valid
      end
    end
  end
end
