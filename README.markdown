Plutus
=================
[![Build Status](https://secure.travis-ci.org/mbulat/plutus.png?branch=master)](http://travis-ci.org/mbulat/plutus)

The Plutus plugin is a Ruby on Rails Engine which provides a double entry accounting system for your application.

### NOTE: This version of Plutus is compatible with RAILS 4.0

For the rails 3 version, you can go here (current master):

[https://github.com/mbulat/plutus](https://github.com/mbulat/plutus)

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

The system consists of tables that maintains your accounts, transactions and debits and credits. Each transaction can have many debits and credits. The transaction table, which records your business transactions is, essentially, your accounting  [Journal](http://en.wikipedia.org/wiki/Journal_entry).

Posting to a [Ledger](http://en.wikipedia.org/wiki/General_ledger) can be considered to happen automatically, since Accounts have the reverse `has_many` relationship to either its credit or debit transactions.

Accounts
--------

The Account class represents accounts in the system. The Account table uses single table inheritance to store information on each type of account (Asset, Liability, Equity, Revenue, Expense). Each account must be sub-classed as one of the following types:

    TYPE        | NORMAL BALANCE    | DESCRIPTION
    --------------------------------------------------------------------------
    Asset       | Debit             | Resources owned by the Business Entity
    Liability   | Credit            | Debts owed to outsiders
    Equity      | Credit            | Owners rights to the Assets
    Revenue     | Credit            | Increases in owners equity
    Expense     | Debit             | Assets or services consumed in the generation of revenue

Your Book of Accounts needs to be created prior to recording any transactions. The simplest method is to have a number of create methods in your db/seeds.rb file like so:

    Plutus::Asset.create(:name => "Accounts Receivable")
    Plutus::Asset.create(:name => "Cash")
    Plutus::Revenue.create(:name => "Sales Revenue")
    Plutus::Liability.create(:name => "Unearned Revenue")
    Plutus::Liability.create(:name => "Sales Tax Payable")
    etc...

Then simply run `rake db:seed`

Each account can also be marked as a "Contra Account". A contra account will have its normal balance swapped. For example, to remove equity, a "Drawing" account may be created as a contra equity account as follows:

    Plutus::Equity.create(:name => "Drawing", :contra => true)

At all times the balance of all accounts should conform to the [Accounting
Equation](http://en.wikipedia.org/wiki/Accounting_equation)

    Assets = Liabilities + Owner's Equity

Every account object has a `has_many` association of credit and debit transactions, which means that each account object also acts as its own [Ledger](http://en.wikipedia.org/wiki/General_ledger), and exposes a method to calculate the balance of the account.  

See the {Plutus::Account}, {Plutus::Transaction}, and {Plutus::Amount} classes for more information.

Examples
========

Recording a Transaction
-----------------------

Let's assume we're accounting on an [Accrual basis](http://en.wikipedia.org/wiki/Accounting_methods#Accrual_basis). We've just taken a customer's order for some widgets, which we've also billed him for. At this point we've actually added a liability to the company until we deliver the goods. To record this transaction we'd need two accounts:

    >> Plutus::Asset.create(:name => "Cash")
    >> Plutus::Liability.create(:name => "Unearned Revenue")

Next we'll build the transaction we want to record. Plutus provides a simple interface to build the transaction. 

    transaction = Plutus::Transaction.build(
                    :description => "Order placed for widgets",
                    :debits => [
                      {:account => "Cash", :amount => 100.00}], 
                    :credits => [
                      {:account => "Unearned Revenue", :amount => 100.00}])

The build method takes a hash consisting of a description, and an array of debits and credits. Each debit and credit item is a hash that specifies the amount, and the account to be debited or credited. Simply pass in the string name you used when you created the account. 

Finally, save the transaction.

    >> transaction.save

If there are any issues with your credit and debit amounts, the save will fail and return false. You can inspect the errors via `transaction.errors`. Because we are doing double-entry accounting, your credit and debit amounts must always cancel out to keep the accounts in balance.

Recording a Transaction with multiple accounts
----------------------------------------------

Often times a single transaction requires more than one type of account. A classic example would be a transaction in which a tax is charged. We'll assume that we have not yet received payment for the order, so we'll need an "Accounts Receivable" Asset:

    >> Plutus::Asset.create(:name => "Accounts Receivable")
    >> Plutus::Revenue.create(:name => "Sales Revenue")
    >> Plutus::Liability.create(:name => "Sales Tax Payable")

And here's the transaction:

    transaction = Plutus::Transaction.build(
                    :description => "Sold some widgets",
                    :debits => [
                      {:account => "Accounts Receivable", :amount => 50}], 
                    :credits => [
                      {:account => "Sales Revenue", :amount => 45},
                      {:account => "Sales Tax Payable", :amount => 5}])
    transaction.save
                       
Associating Documents
---------------------

Although Plutus does not provide a mechanism for generating invoices or orders, it is possible to associate any such commercial document with a given transaction.

Suppose we pull up our latest invoice in order to generate a transaction for plutus (we'll assume you already have an Invoice model):

    >> invoice = Invoice.last

Let's assume we're using the same transaction from the last example

    transaction = Plutus::Transaction.build(
                    :description => "Sold some widgets",
                    :commercial_document => invoice,
                    :debits => [
                      {:account => "Accounts Receivable", :amount => invoice.total_amount}], 
                    :credits => [
                      {:account => "Sales Revenue", :amount => invoice.sales_amount},
                      {:account => "Sales Tax Payable", :amount => invoice.tax_amount}])
    transaction.save

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

    Assets = Liabilities + Owner's Equity

For example, let's assume the owner of a business wants to withdraw cash. First we'll assume that we have an asset account for "Cash" which the funds will be drawn from. We'll then need an Equity account to record where the funds are going, however, in this case, we can't simply create a regular Equity account. The "Cash" account must be credited for the decrease in its balance since it's an Asset. Likewise, Equity accounts are typically credited when there is an increase in their balance. Equity is considered an owner's rights to Assets in the business. In this case however, we are not simply increasing the owner's rights to assets within the business; we are actually removing capital from the business altogether. Hence both sides of our accounting equation will see a decrease. In order to accomplish this, we need to create a Contra-Equity account we'll call "Drawings". Since Equity accounts normally have credit balances, a Contra-Equity account will have a debit balance, which is what we need for our transaction. 

    >> Plutus::Equity.create(:name => "Drawing", :contra => true)
    >> Plutus::Asset.create(:name => "Cash")

We would then create the following transaction:

    transaction = Plutus::Transaction.build(
                    :description => "Owner withdrawing cash",
                    :debits => [
                      {:account => "Drawing", :amount => 1000}], 
                    :credits => [
                      {:account => "Cash", :amount => 1000}])
    transaction.save

To make the example clearer, imagine instead that the owner decides to invest his money into the business in exchange for some type of equity security. In this case we might have the following accounts:

    >> Plutus::Equity.create(:name => "Common Stock")
    >> Plutus::Asset.create(:name => "Cash")

And out transaction would be:

    transaction = Plutus::Transaction.build(
                    :description => "Owner investing cash",
                    :debits => [
                      {:account => "Cash", :amount => 1000}], 
                    :credits => [
                      {:account => "Common Stock", :amount => 1000}])
    transaction.save

In this case, we've increase our cash Asset, and simultaneously increased the other side of our accounting equation in
Equity, keeping everything balanced.

Access & Security
=================

The Engine provides controllers and views for viewing Accounts and Transactions via the {Plutus::AccountsController} and {Plutus::TransactionsController} classes. The controllers will render HTML, XML and JSON, and are compatible with [ActiveResource](http://api.rubyonrails.org/classes/ActiveResource/Base.html)

These controllers are read-only for reporting purposes. It is assumed transaction creation will occur within your applications code.

Routing is supplied via an engine mount point. Plutus can be mounted on a subpath in your existing Rails 3 app by adding the following to your routes.rb:

    mount Plutus::Engine => "/plutus", :as => "plutus"

*NOTE: If you enable routing, you should ensure that your ApplicationController enforces its own authentication and authorization, which this controller will inherit.*

Sample stylesheets can also be applied by adding the following to your application layout:

    <%= stylesheet_link_tag    "plutus/application" %>

Testing
=======

[Rspec](http://rspec.info/) tests are provided. Run `bundle install` then `rake`.  

Community and where to get help
===============================

* Join the [mailing list](https://groups.google.com/d/forum/plutus-gem) (Google Group)

ToDo
====

* Better views, including paging and ledgers
* Reference for common accounting transactions

Reference
=========

For a complete reference on Accounting principles, we recommend the following textbook 

[http://amzn.com/0324662963](http://amzn.com/0324662963)

* * *

Copyright (c) 2010-2012 Michael Bulat
