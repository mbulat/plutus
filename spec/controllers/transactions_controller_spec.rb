require 'spec_helper'

describe TransactionsController do

  def mock_transaction(stubs={})
    @mock_transaction ||= mock_model(Transaction, stubs)
  end
  
  describe "GET index" do
    it "assigns all transactions as @transactions" do
      Transaction.stub(:find).with(:all).and_return([mock_transaction])
      get :index
      assigns[:transactions].should == [mock_transaction]
    end
  end

end
