shared_examples_for 'a Plutus::Account subtype' do |elements|
  let(:contra) { false }
  let(:account) { FactoryGirl.create(elements[:kind], contra: contra)}
  subject { account }

  describe "class methods" do
    subject { account.class }
    its(:balance) { should be_kind_of(BigDecimal) }
    describe "trial_balance" do
      it "should raise NoMethodError" do
        lambda { subject.trial_balance }.should raise_error NoMethodError
      end
    end
  end

  describe "instance methods" do
    its(:balance) { should be_kind_of(BigDecimal) }

    it { should respond_to(:credit_entries) }
    it { should respond_to(:debit_entries) }
  end

  it "requires a name" do
    account.name = nil
    account.should_not be_valid
  end

  # Figure out which way credits and debits should apply
  if elements[:normal_balance] == :debit
     debit_condition = :>
    credit_condition = :<
  else
    credit_condition = :>
     debit_condition = :<
  end

  describe "when given a debit" do
    before { FactoryGirl.create(:debit_amount, account: account) }
    its(:balance) { should be.send(debit_condition, 0) }

    describe "on a contra account" do
      let(:contra) { true }
      its(:balance) { should be.send(credit_condition, 0) }
    end
  end

  describe "when given a credit" do
    before { FactoryGirl.create(:credit_amount, account: account) }
    its(:balance) { should be.send(credit_condition, 0) }

    describe "on a contra account" do
      let(:contra) { true }
      its(:balance) { should be.send(debit_condition, 0) }
    end
  end
end
