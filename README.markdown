Plutus
=================
[![Build Status](https://secure.travis-ci.org/mbulat/plutus.png?branch=master)](http://travis-ci.org/mbulat/plutus)

This plutus plugin is a Ruby on Rails Engine which provides a double entry accounting system for your application.

NOTE: This version of Plutus is compatable with RAILS 3.1
=======================================================

For the rails 2 version, you can go here:

[https://github.com/mbulat/plutus/tree/rails2](https://github.com/mbulat/plutus/tree/rails2)

Gems in RubyGems.org >= 0.5.0 support Rails 3

Installation
============

- Add the gem to your Gemfile `gem "plutus"`

- generate migration files `rails g plutus`

- run migrations `rake db:migrate`

Overview
========

The plutus plugin provides a complete double entry accounting system for use in any Ruby on Rails application. The plugin follows general [Double Entry Bookkeeping](http://en.wikipedia.org/wiki/Double-entry_bookkeeping_system) practices. All calculations are done using [BigDecimal](http://www.ensta.fr/~diam/ruby/online/ruby-doc-stdlib/libdoc/bigdecimal/rdoc/classes/BigDecimal.html) in order to prevent floating point rounding errors. The plugin requires a decimal type on your database as well.

The system consists of tables that maintains your account, transactions and debits and credits. Each transaction can have many debits and credits. The transaction table, which records your business transactions is, essentially, your accounting  [Journal](http://en.wikipedia.org/wiki/Journal_entry) 

Posting to a [Ledger](http://en.wikipedia.org/wiki/General_ledger) can be considered to happen automatically, since Accounts have the reverse `has_many` relationship to either its credit or debit transactions 

Accounts
--------

The Account class represents accounts in the system. The Account table uses single table inheritance to store information on each type of account (Asset, Liability, Equity, Revenue, Expense). Each account must be subclassed as one of the following types:

    TYPE        | NORMAL BALANCE    | DESCRIPTION
    --------------------------------------------------------------------------
    Asset       | Debit             | Resources owned by the Business Entity
    Liability   | Credit            | Debts owed to outsiders
    Equity      | Credit            | Owners rights to the Assets
    Revenue     | Credit            | Increases in owners equity
    Expense     | Debit             | Assets or services consumed in the generation of revenue

Each account can also be marked as a "Contra Account". A contra account will have its normal balance swapped. For example, to remove equity, a "Drawing" account may be created as a contra equity account as follows:

    Plutus::Equity.create(:name => "Drawing", contra => true)

At all times the balance of all accounts should conform to the [Accounting
Equation](http://en.wikipedia.org/wiki/Accounting_equation)

    Assets = Liabilties + Owner's Equity

Every account object has a `has_many` association of credit and debit transactions, which means that each account object also acts as its own [Ledger](http://en.wikipedia.org/wiki/General_ledger), and exposes a method to calculate the balance of the account.  

See the {Plutus::Account}, {Plutus::Transaction}, and {Plutus::Amount} classes for more information.



Examples
========

Recording a Transaction
-----------------------

Let's assume we're accounting on an [Accrual basis](http://en.wikipedia.org/wiki/Accounting_methods). We've just taken a customer's order for some widgets, which we've also billed him for. At this point we've actually added a liability to the company until we deliver the goods. To record this transaction we'd need two accounts:

    >> cash = Plutus::Asset.create(:name => "Cash")
    >> unearned_revenue = Plutus::Liability.create(:name => "Unearned Revenue")

Next we'll setup the transaction we want to record:

    >> transaction = Plutus::Transaction.new(:description => "Order placed for widgets")

We then specify the amount that is debited and credited from each account for this transaction:

    >> transaction.debit_amounts << Plutus::DebitAmount.new(:amount => 1000, account: cash, transaction: transaction) 
    >> transaction.credit_amounts << Plutus::CreditAmount.new(:amount => 1000, account: unearned_revenue, transaction: transaction)

Finally, save the transaction, which saves the corresponsing credit and debit amounts.

    >> transaction.save

Recording a Transaction with multiple accounts
----------------------------------------------

Often times a single transaction requires more than one type of account. A classic example would be a transaction in which a tax is charged. We'll assume that we have not yet received payment for the order, so we'll need an "Accounts Receivable" Asset:

    >> accounts_receivable = Plutus::Asset.create(:name => "Accounts Receivable")
    >> sales_revenue = Plutus::Revenue.create(:name => "Sales Revenue")
    >> sales_tax_payable = Plutus::Liability.create(:name => "Sales Tax Payable")

Next we'll setup the transaction:

    >> transaction = Plutus::Transaction.new(:description => "Sold some widgets")

And now we apply the amounts:

    >> transaction.debit_amounts << Plutus::DebitAmount.new(:amount => 1060, account: accounts_receivable, transaction: transaction) 
    >> transaction.credit_amounts << Plutus::CreditAmount.new(:amount => 1000, account: sales_revenue, transaction: transaction)
    >> transaction.credit_amounts << Plutus::CreditAmount.new(:amount => 60, account: sales_tax_payable, transaction: transaction)

Finally, save the transaction, which saves the corresponsing credit and debit amounts.

    >> transaction.save

Note, your credit and debit amounts must always cancel out to keep the accounts in balance.

                       
Associating Documents
---------------------

Although Plutus does not provide a mechanism for generating invoices or orders, it is possible to associate any such commercial document with a given transaction.

Suppose we pull up our latest invoice in order to generate a transaction for plutus (we'll assume you already have an Invoice model):

    >> invoice = Invoice.last

Let's assume we're using the same transaction from the last example

    >> transaction = Plutus::Transaction.new(:description => "Sold some widgets", :commercial_document => invoice)
    >> transaction.debit_amounts << Plutus::DebitAmount.new(:amount => invoice.total_amount, account: accounts_receivable, transaction: transaction) 
    >> transaction.credit_amounts << Plutus::CreditAmount.new(:amount => invoice.sales_amount, account: sales_revenue, transaction: transaction)
    >> transaction.credit_amounts << Plutus::CreditAmount.new(:amount => invoice.tax_amount, account: sales_tax_payable, transaction: transaction)

The commercial document attribute on the transaction is a polymorphic association allowing you to associate any record from your models with a transaction (i.e. Bills, Invoices, Receipts, Returns, etc.)

Checking the Balance of an  Individual Account
----------------------------------------------
  
Each account can report on its own balance. This number should normally be positive. If the number is negative, you may have a problem.

    >> cash = Plutus::Asset.find_by_name("Cash")
    >> cash.balance
    => #<BigDecimal:103259bb8,'0.2E4',4(12)>

    
Checking the Balance of an Account Type
---------------------------------------

Each subclass of accounts can report on the total balance of all the accounts of that type. This number should normally be positive. If the number is negative, you may have a problem.

    >> Plutus::Asset.balance
    => #<BigDecimal:103259bb8,'0.2E4',4(12)>    
    
Calculating the Trial Balance
-----------------------------

The [Trial Balance](http://en.wikipedia.org/wiki/Trial_balance) for all accounts on the system can be found through the abstract Account class. This value should be 0 unless there is an error in the system.

    >> Plutus::Account.trial_balance
    => #<BigDecimal:1031c0d28,'0.0',4(12)>

Contra Accounts and Complex Transactions
----------------------------------------

For complex transaction, you should always ensure that you are balancing your accounts via the [Accounting Equation](http://en.wikipedia.org/wiki/Accounting_equation).

    Assets = Liabilties + Owner's Equity

For example, let's assume the owner of a business wants to withdraw cash. First we'll assume that we have an asset account for "Cash" which the funds will be drawn from. We'll then need an Equity account to record where the funds are going, however, in this case, we can't simply create a regular Equity account. The "Cash" account must be credited for the decrease in its balance since it's an Asset. Likewise, Equity accounts are typically credited when there is an increase in their balance. Equity is considered an owner's rights to Assets in the business. In this case however, we are not simply increasing the owners right's to assets within the business; we are actually removing capital from the business altogether. Hence both sides of our accounting equation will see a decrease. In order to accomplish this, we need to create a Contra-Equity account we'll call "Drawings". Since Equity accounts normally have credit balances, a Contra-Equity account will have a debit balance, which is what we need for our transaction. 

    >> drawing = Plutus::Equity.create(:name => "Drawing", :contra => true)
    >> cash = Plutus::Asset.create(:name => "Cash")
  
We would then create the following transaction:

    >> transaction = Plutus::Transaction.new(:description => "Owner withdrawing cash")
    >> transaction.debit_amounts << Plutus::DebitAmount.new(:amount => 1000, account: drawing, transaction: transaction) 
    >> transaction.credit_amounts << Plutus::CreditAmount.new(:amount => 1000, account: cash, transaction: transaction)
    >> transaction.save

To make the example clearer, imagine instead that the owner decides to invest his money into the business in exchange for some type of equity security. In this case we might have the following accounts:

    >> common_stock = Plutus::Equity.create(:name => "Common Stock")
    >> cash = Plutus::Asset.create(:name => "Cash")

And out transaction would be:

    >> transaction = Plutus::Transaction.new(:description => "Owner investing cash")
    >> transaction.debit_amounts << Plutus::DebitAmount.new(:amount => 1000, account: cash, transaction: transaction) 
    >> transaction.credit_amounts << Plutus::CreditAmount.new(:amount => 1000, account: common_stock, transaction: transaction)
    >> transaction.save

In this case, we've increase our cash Asset, and simultaneously increased the other side of our accounting equation in
Equity, keeping everything balanced.

Access & Security
=================

The Engine provides controllers and views for viewing Accounts and Transactions via the {Plutus::AccountsController} and {Plutus::TransactionsController} classes. The controllers will render HTML, XML and JSON, and are compatible with [ActiveResource](http://api.rubyonrails.org/classes/ActiveResource/Base.html)

Routing is supplied via an engine mount point. Plutus can be mounted on a subpath in your existing Rails 3 app by adding the following to your routes.rb:

    mount Plutus::Engine => "/plutus", :as => "plutus"

*NOTE: If you enable routing, you should ensure that your ApplicationController enforces its own authentication and authorization, which this controller will inherit.*

Testing
=======

[Rspec](http://rspec.info/) tests are provided. Run `bundle install` then `rake`.  

ToDo
====

* Better views, including paging and ledgers
* Reference for common accounting transactions

Reference
=========

For a complete reference on Accounting principles, we recommend the following textbook 

[http://amzn.com/0324662963](http://amzn.com/0324662963)

* * *

Copyright (c) 2010 Michael Bulat
