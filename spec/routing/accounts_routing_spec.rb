require 'spec_helper'

module Plutus
  describe AccountsController do
    routes { Plutus::Engine.routes }

    describe "routing" do
      it "recognizes and generates #index" do
        { :get => "/accounts" }.should route_to(:controller => "plutus/accounts", :action => "index")
      end
    end
  end
end
