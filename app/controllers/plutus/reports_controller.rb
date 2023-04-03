module Plutus
  # == Security:
  # Only GET requests are supported. You should ensure that your application
  # controller enforces its own authentication and authorization, which this
  # controller will inherit.
  #
  # @author Michael Bulat
  class ReportsController < ::Plutus::ApplicationController
    unloadable if respond_to?(:unloadable)

    # @example
    #   GET /reports/balance_sheet
    def balance_sheet
      first_entry = Plutus::Entry.order('date ASC').first
      @from_date = first_entry ? first_entry.date: Date.today
      @to_date = params[:date] ? Date.parse(params[:date]) : Date.today
      @assets = Plutus::Asset.all
      @liabilities = Plutus::Liability.all
      @equity = Plutus::Equity.all

      respond_to do |format|
        format.html # index.html.erb
      end
    end

    # @example
    #   GET /reports/income_statement
    def income_statement
      @from_date = params[:from_date] ? Date.parse(params[:from_date]) : Date.today.at_beginning_of_month
      @to_date = params[:to_date] ? Date.parse(params[:to_date]) : Date.today
      @revenues = Plutus::Revenue.all
      @expenses = Plutus::Expense.all

      respond_to do |format|
        format.html # index.html.erb
      end
    end

  end
end
