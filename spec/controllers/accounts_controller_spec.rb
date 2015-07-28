require 'spec_helper'

module Plutus
  describe AccountsController do
    routes { Plutus::Engine.routes }

    def mock_account(stubs={})
      @mock_account ||= FactoryGirl.create(:asset)
    end

    describe "GET index" do
      it "assigns all accounts as @accounts" do
        Account.stub(:all).and_return([mock_account])
        get :index
        assigns[:accounts].should == [mock_account]
      end
    end
  end
end
