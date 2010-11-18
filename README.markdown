Plutus
=================

This plutus plugin is a Ruby on Rails Engine which provides a double entry accounting system for your application.

Installation
============

- install plugin `./script/plugin install plutus`

- generate migration files `./script/generate plutus plutus`

- run migrations `rake db:migrate`

Overview
========

The plutus plugin provides a complete double entry accounting system for use in any Ruby on Rails application. The plugin follows general [Double Entry Bookkeeping](http://en.wikipedia.org/wiki/Double-entry_bookkeeping_system) practices. All calculations are done using [BigDecimal](http://www.ensta.fr/~diam/ruby/online/ruby-doc-stdlib/libdoc/bigdecimal/rdoc/classes/BigDecimal.html) in order to prevent floating point rounding errors. The plugin requires a decimal type on your database as well.

The system consists of a table that maintains your accounts and a table for recording transactions. The Account table uses single table inheritance to store information on each type of account (Asset, Liability, Equity, Revenue, Expense). The transaction table, which records your business transactions, is essentially your accounting  [Journal](http://en.wikipedia.org/wiki/Journal_entry)

Every account object has a 'has_many' association of credit and debit transactions, which means that each account object also acts as it's own [Ledger](http://en.wikipedia.org/wiki/General_ledger), and exposes a method to calculate the balance of the account.  

See the {Account} and {Transaction} classes for more information.

Example
=======

Recording a Transaction
-----------------------

  Let's assume the owner of the business wants to withdraw money from the business. First we'll assume that an asset account for "Cash" as well as a contra-equity account for "Drawings" has been setup

    >> Equity.create(:name => "Drawing", :contra => true)
    >> Asset.create(:name => "Cash")
  
  In order to record cash being withdrawn from the business by the owner, we would create the following transaction

    >> Transaction.create(:description => "Owner withdrawing cash", 
                       :credit_account => Asset.find_by_name("Cash"),
                       :debit_account => Equity.find_by_name("Drawing"), 
                       :amount => 1000)
                       
                       
Checking the Balance of an  Individual Account
----------------------------------------------
  
  Each account can report on it's own balance. This number should normally be positive. If the number is negative, you may have a problem.
  
    >> cash = Asset.find_by_name("Cash")
    >> cash.balance
    => #<BigDecimal:103259bb8,'0.2E4',4(12)>

    
Checking the Balance of an Account SubClass
-------------------------------------------

  Each subclass of accounts can report on the total balance of all the accounts of that type. This number should normally be positive. If the number is negative, you may have a problem.

    >> Asset.balance
    => #<BigDecimal:103259bb8,'0.2E4',4(12)>    
    
Calculating the Trial Balance
-----------------------------

  The [Trial Balance](http://en.wikipedia.org/wiki/Trial_balance) for all accounts on the system can be found through the abstract Account class. This value should be 0 unless there is an error in the system.

    >> Account.trial_balance
    => #<BigDecimal:1031c0d28,'0.0',4(12)>


Access & Security
=================

The Engine provides controllers and views for accessing Accounts and Transactions via the {AccountsController} and {TransactionsController}  classes. The controllers will render HTML, XML and JSON, and are compatible with [ActiveResource](http://api.rubyonrails.org/classes/ActiveResource/Base.html)

Routing is also supplied by the Engine.

Only GET requests are supported. You should ensure that your application controller enforces its own authentication and authorization, which this controller will inherit.  

Testing
=======

[Rspec](http://rspec.info/) tests are provided. Install both the rpsec and rspec-rails gems to run the tests.

* * *

Copyright (c) 2009 The Tidewinds Group Inc. All Rights Reserved.
