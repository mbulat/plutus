require 'spec_helper'

module Plutus
  describe Amount do

    it "should not allow creating an amount without a subtype" do
      amount = FactoryGirl.build(:amount)
      amount.should_not be_valid
    end

  end
end
