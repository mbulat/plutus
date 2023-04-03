require 'spec_helper'

module Plutus
  describe Amount do

    describe "attributes" do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
    end

    subject { FactoryGirl.build(:amount) }
    it { is_expected.not_to be_valid }  # construct a child class instead
  end
end
