require 'spec_helper'

module Plutus
  describe Account do
    describe 'tenancy support' do

      before(:all) do
				m = ActiveRecord::Migration.new
				m.verbose = false
				m.create_table :plutus_tenants do |t|
					t.string :name
				end
      end

			after :all do
				m = ActiveRecord::Migration.new
				m.verbose = false
				m.drop_table :plutus_tenants
			end

      before(:each) do
        ActiveSupportHelpers.clear_model('Account')
        ActiveSupportHelpers.clear_model('Asset')

        Plutus.enable_tenancy = true
        Plutus.tenant_class = 'Plutus::Tenant'

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
        tenant = FactoryGirl.create(:tenant)
        account = FactoryGirl.create(:asset, tenant: tenant)

        record = FactoryGirl.build(:asset, name: account.name, tenant: tenant)
        expect(record).not_to be_valid
        expect(record.errors[:name]).to eq(['has already been taken'])
      end

      it 'allows same name scoped under a different tenant' do
        tenant_1 = FactoryGirl.create(:tenant)
        tenant_2 = FactoryGirl.create(:tenant)
        account = FactoryGirl.create(:asset, tenant: tenant_1)

        record = FactoryGirl.build(:asset, name: account.name, tenant: tenant_2)
        expect(record).to be_valid
      end
    end
  end
end
