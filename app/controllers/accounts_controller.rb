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
class AccountsController < ApplicationController
  unloadable
  
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
  
  # @example
  #   GET /accounts/1
  #   GET /accounts/1.xml
  #   GET /accounts/1.json
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
      format.json  { render :json => @account }
    end
  end  
  
end
