require 'rails_helper'

module Plutus
  describe AccountsController, :type => :controller do
    routes { Plutus::Engine.routes }

    def mock_account(stubs={})
      @mock_account ||= FactoryBot.create(:asset)
    end

    describe "GET index" do
      it "assigns all accounts as @accounts" do
        allow(Account).to receive(:all).and_return([mock_account])
        get :index
        expect(assigns[:accounts]).to eq([mock_account])
      end
    end
  end
end
