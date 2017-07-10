require 'spec_helper'

module Plutus
  describe EntriesController do
    routes { Plutus::Engine.routes }

    def mock_entry(stubs={})
      @mock_entry ||= FactoryGirl.create(:entry_with_credit_and_debit)
    end

    describe "GET index" do
      it "assigns all entries as @entries" do
        Entry.stub_chain(:per, :order).and_return([mock_entry])
        get :index
        assigns[:entries].should == [mock_entry]
      end
    end
  end
end
