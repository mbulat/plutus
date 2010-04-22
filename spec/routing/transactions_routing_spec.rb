require 'spec_helper'

describe TransactionsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/transactions" }.should route_to(:controller => "transactions", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/transactions/1" }.should route_to(:controller => "transactions", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/transactions/1/edit" }.should_not be_routable
    end

    it "recognizes and generates #create" do
      { :post => "/transactions" }.should_not be_routable
    end

    it "recognizes and generates #update" do
      { :put => "/transactions/1" }.should_not be_routable
    end

    it "recognizes and generates #destroy" do
      { :delete => "/transactions/1" }.should_not be_routable
    end
  end
end
