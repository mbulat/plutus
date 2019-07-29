module Plutus
  # Association extension for has_many :amounts relations. Internal.
  module AmountsExtension
    # Returns a sum of the referenced Amount objects.
    #
    # Takes a hash specifying :from_date and :to_date for calculating balances during periods.
    # :from_date and :to_date may be strings of the form "yyyy-mm-dd" or Ruby Date objects
    #
    # This runs the summation in the database, so it only works on persisted records.
    #
    # @example
    #   credit_amounts.balance({:from_date => "2000-01-01", :to_date => Date.today})
    #   => #<BigDecimal:103259bb8,'0.2E4',4(12)>
    #
    # @return [BigDecimal] The decimal value balance
    def balance(hash={})
      if hash[:from_date] && hash[:to_date]
        from_date = hash[:from_date].kind_of?(Date) ? hash[:from_date] : Date.parse(hash[:from_date])
        to_date = hash[:to_date].kind_of?(Date) ? hash[:to_date] : Date.parse(hash[:to_date])
        includes(:entry).where('plutus_entries.date' => from_date..to_date).sum(:amount)
      else
        sum(:amount)
      end
    end

    # Returns a sum of the referenced Amount objects.
    #
    # This is used primarly in the validation step in Plutus::Entry
    # in order to ensure that the debit and credits are canceling out.
    #
    # Since this does not use the database for sumation, it may be used on non-persisted records.
    def balance_for_new_record
      balance = BigDecimal('0')
      each do |amount_record|
        if amount_record.amount && !amount_record.marked_for_destruction?
          balance += amount_record.amount # unless amount_record.marked_for_destruction?
        end
      end
      return balance
    end
  end
end
