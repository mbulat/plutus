module Plutus
  # This controller provides restful route handling for Entries.
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
  class EntriesController < ApplicationController
    unloadable
    # @example
    #   GET /entries
    #   GET /entries.xml
    #   GET /entries.json
    def index
      @entries = Entry.all

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @entries }
        format.json  { render :json => @entries }
      end
    end

    # @example
    #   GET /entries/1
    #   GET /entries/1.xml
    #   GET /entries/1.json
    def show
      @entry = Entry.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @entry }
        format.json  { render :json => @entry }
      end
    end

  end
end
