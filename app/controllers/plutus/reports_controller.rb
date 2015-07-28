module Plutus
  # == Security:
  # Only GET requests are supported. You should ensure that your application
  # controller enforces its own authentication and authorization, which this
  # controller will inherit.
  #
  # @author Michael Bulat
  class ReportsController <  Plutus::ApplicationController
    unloadable

    # @example
    #   GET /reports/balance_sheet
    def balance_sheet
      @from_date = Plutus::Entry.order('date ASC').first.date
      @to_date = params[:date] ? Date.parse(params[:date]) : Date.today
      @assets = Plutus::Asset.all
      @liabilities = Plutus::Liability.all
      @equity = Plutus::Equity.all

      respond_to do |format|
        format.html # index.html.erb
      end
    end

  end
end
