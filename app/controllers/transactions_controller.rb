class TransactionsController < ApplicationController
  unloadable
  
  def index
    @transactions = Transaction.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transactions }
      format.json  { render :json => @transactions }
    end
  end
end
