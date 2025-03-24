require 'spec_helper'

module Plutus
  describe EntriesController, type: :routing do
    routes { Plutus::Engine.routes }

    describe "routing" do
      it "recognizes and generates #index" do
        expect(:get => "/entries").to route_to(:controller => "plutus/entries", :action => "index")
      end
    end
  end
end
