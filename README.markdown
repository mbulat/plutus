DoubleEntryAccounting
=================

This double_entry_accounting plugin provides an accounting engine for Ruby on Rails applications.

Installation
============

- install plugin `./script/plugin install double_entry_accounting`

- generate migration files `./script/generate double_entry_accounting double_entry_accounting`

- run migrations `rake db:migrate`

Overview
========

The double_entry_accounting plugin provides a complete double entry accounting system for use in any Ruby on Rails application. The plugin follows general [Double Entry Bookkeeping](http://en.wikipedia.org/wiki/Double-entry_bookkeeping_system) practices.

The system consists of a table that maintains your accounts. This table uses single table inheritance to store information on each type of account (Asset, Liability, Equity, Revenue, Expense). 

The system also includes a table which records your business transactions. This table is essentially a [Journal](http://en.wikipedia.org/wiki/Journal_entry)

Every account object has a 'has_many' association of credit and debit transactions, which means that each account object also acts as it's own [Ledger](http://en.wikipedia.org/wiki/General_ledger), and exposes a method to calculate the balance of the account.  

See {Account} and {Transaction} for more information.

Example
=======

Recording a Transaction
-----------------------

  Let's assume the owner of the business wants to withdraw money from the business. First we'll assume an asset account for "Cash" as well as a contra-equity account for "Drawings" has been setup

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

    
Checking the Balance of an Account Class
----------------------------------------

  Each class of accounts can report on the total balance of all the accounts of that type. This number should normally be positive. If the number is negative, you may have a problem.

    >> Asset.balance
    => #<BigDecimal:103259bb8,'0.2E4',4(12)>    
    
Calculating the Trial Balance
-----------------------------

  The [Trial Balance](http://en.wikipedia.org/wiki/Trial_balance) for all accounts on the system can be found through the abstract Account class. This value should be 0 unless there is an error in the system.

    >> Account.trial_balance
    => #<BigDecimal:1031c0d28,'0.0',4(12)>

  
* * *

Copyright (c) 2009 The Tidewinds Group Inc. All Rights Reserved.