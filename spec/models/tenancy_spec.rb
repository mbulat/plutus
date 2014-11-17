require 'spec_helper'

module Plutus
  describe Account do
    describe 'tenancy support' do
      before(:each) do
        ActiveSupportHelpers.clear_model('Account')
        ActiveSupportHelpers.clear_model('Asset')

        Plutus.enable_tenancy = true
        Plutus.tenant_class = 'Plutus::Entry'

        FactoryGirlHelpers.reload()
        Plutus::Asset.new
      end

      after(:each) do
        if Plutus.const_defined?(:Asset)
          ActiveSupportHelpers.clear_model('Account')
          ActiveSupportHelpers.clear_model('Asset')
        end

        Plutus.enable_tenancy = false
        Plutus.tenant_class = nil

        FactoryGirlHelpers.reload()
      end

      it 'validate uniqueness of name scoped to tenant' do
        account = FactoryGirl.create(:asset, tenant_id: 10)

        record = FactoryGirl.build(:asset, name: account.name, tenant_id: 10)
        record.should_not be_valid
        record.errors[:name].should == ['has already been taken']
      end

      it 'allows same name scoped under a different tenant' do
        account = FactoryGirl.create(:asset, tenant_id: 10)

        record = FactoryGirl.build(:asset, name: account.name, tenant_id: 11)
        record.should be_valid
      end
    end
  end
end
