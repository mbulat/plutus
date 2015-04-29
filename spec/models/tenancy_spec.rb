require 'spec_helper'

module Plutus
  describe Account do
    describe 'tenancy support' do
      shared_examples_for 'account tenancy' do |attribute_name|

        before(:each) do
          ActiveSupportHelpers.clear_model('Account')
          ActiveSupportHelpers.clear_model('Asset')

          Plutus.enable_tenancy = true
          Plutus.tenant_class = 'Plutus::Entry'
          Plutus.tenant_attribute_name = attribute_name

          FactoryGirlHelpers.reload()
          # require 'spec_helper' # reload schema etc

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
          account = FactoryGirl.create(:asset, "#{attribute_name}_id": 10)
          record = FactoryGirl.build(:asset, name: account.name, "#{attribute_name}_id": 10)
          record.should_not be_valid
          record.errors[:name].should == ['has already been taken']
        end

        it 'allows same name scoped under a different tenant' do
          account = FactoryGirl.create(:asset, "#{attribute_name}_id": 10)
          record = FactoryGirl.build(:asset, name: account.name, "#{attribute_name}_id": 11)
          record.should be_valid
        end
      end

      it_behaves_like 'account tenancy', 'tenant'

      # For this to work, would need to unload rails, and in the before above re-require rspec_helper to load models and schema matching the different attribute name.
      # it_behaves_like 'account tenancy', 'books'
    end
  end
end
