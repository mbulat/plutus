module Plutus
  # Association extension for has_many :amounts relations. Internal.
  module AmountsExtension
    # Returns a sum of the referenced Amount objects.
    #
    # Takes a hash specifying several options:
    # * passing in :from_date and :to_date calculates balances during periods.
    #   :from_date and :to_date may be strings of the form "yyyy-mm-dd" or Ruby
    #   Date objects.
    # * passing in :commercial_document calculates balances only for entries
    #   involving that document. :commercial_document is expected to be an
    #   instance of an ActiveRecord object.
    #
    # This runs the summation in the database, so it only works on persisted records.
    #
    # @example
    #   credit_amounts.balance({:from_date => "2000-01-01", :to_date => Date.today})
    #   => #<BigDecimal:103259bb8,'0.2E4',4(12)>
    #
    # @return [BigDecimal] The decimal value balance
    def balance(options = {})
      relation = self

      if options[:from_date] && options[:to_date]
        from_date = options[:from_date].is_a?(Date) ? options[:from_date] : Date.parse(options[:from_date])
        to_date = options[:to_date].is_a?(Date) ? options[:to_date] : Date.parse(options[:to_date])
        relation = relation.includes(:entry).where('plutus_entries.date' => from_date..to_date)
      end

      if (doc = options[:commercial_document])
        cd_id = doc.id
        cd_type = doc.class.name

        relation = relation
                   .includes(:entry)
                   .where(<<~SQL, cd_id: cd_id, cd_type: cd_type)
                     plutus_entries.commercial_document_id = :cd_id
                     AND
                     plutus_entries.commercial_document_type = :cd_type
                   SQL
      end

      relation.sum(:amount)
    end

    # Returns a sum of the referenced Amount objects.
    #
    # This is used primarly in the validation step in Plutus::Entry
    # in order to ensure that the debit and credits are canceling out.
    #
    # Since this does not use the database for sumation, it may be used on non-persisted records.
    def balance_for_new_record
      balance = BigDecimal.new('0')
      each do |amount_record|
        if amount_record.amount && !amount_record.marked_for_destruction?
          balance += amount_record.amount # unless amount_record.marked_for_destruction?
        end
      end
      return balance
    end
  end
end
