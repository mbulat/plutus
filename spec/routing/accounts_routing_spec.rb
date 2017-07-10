require 'spec_helper'

module Plutus
  describe AccountsController do
    routes { Plutus::Engine.routes }

    describe "routing" do
      it "recognizes and generates #index" do
        expect(:get => "/accounts").to route_to(:controller => "plutus/accounts", :action => "index")
      end
    end
  end
end
