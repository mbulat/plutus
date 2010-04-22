require 'spec_helper'

describe AccountsController do

  def mock_account(stubs={})
    @mock_account ||= mock_model(Account, stubs)
  end
  
  describe "GET index" do
    it "assigns all accounts as @accounts" do
      Account.stub(:find).with(:all).and_return([mock_account])
      get :index
      assigns[:accounts].should == [mock_account]
    end
  end

end
