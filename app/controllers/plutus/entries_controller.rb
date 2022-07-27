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
  class EntriesController <  Plutus::ApplicationController
    # @example
    #   GET /entries
    #   GET /entries.xml
    #   GET /entries.json
    def index
      if params[:order] == 'ascending'
        order = 'ASC'
      else
        order = 'DESC'
      end
      @entries = Entry.page(params[:page]).per(params[:limit]).order("date #{order}")

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @entries }
        format.json  { render :json => @entries }
      end
    end
  end
end
