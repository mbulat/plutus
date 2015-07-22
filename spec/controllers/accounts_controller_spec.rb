require 'spec_helper'

module Plutus
  describe AccountsController do
    routes { Plutus::Engine.routes }

    def mock_account(stubs={})
      @mock_account ||= mock_model(Account, stubs)
    end

    describe "GET index" do
      it "assigns all accounts as @accounts" do
        Account.stub(:all).and_return([mock_account])
        get :index
        assigns[:accounts].should == [mock_account]
      end
    end

    describe "GET show" do
      it "assigns the requested account as @account" do
        Account.stub(:find).with("37").and_return(mock_account)
        get :show, :id => "37"
        assigns[:account].should equal(mock_account)
      end
    end

  end
end
