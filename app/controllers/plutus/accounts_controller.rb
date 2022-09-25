module Plutus
  # This controller provides restful route handling for Accounts.
  #
  # The controller supports ActiveResource, and provides for
  # HMTL, XML, and JSON presentation.
  #
  # == Security:
  # Only GET requests are supported. You should ensure that your application
  # controller enforces its own authentication and authorization, which this
  # controller will inherit.
  #
  # @author Michael Bulat
  class AccountsController < ::Plutus::ApplicationController
    unloadable if respond_to?(:unloadable)

    # @example
    #   GET /accounts
    #   GET /accounts.xml
    #   GET /accounts.json
    def index
      @accounts = Account.all

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @accounts }
        format.json  { render :json => @accounts }
      end
    end
  end
end
