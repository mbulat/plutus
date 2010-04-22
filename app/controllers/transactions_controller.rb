# This controller provides restful route handling for Transactions.
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
class TransactionsController < ApplicationController
  unloadable
  # @example
  #   GET /transactions
  #   GET /transactions.xml
  #   GET /transactions.json
  def index
    @transactions = Transaction.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transactions }
      format.json  { render :json => @transactions }
    end
  end
  
  # @example
  #   GET /transactions/1
  #   GET /transactions/1.xml
  #   GET /transactions/1.json  
  def show
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transaction }
      format.json  { render :json => @transaction }
    end
  end
  
end
