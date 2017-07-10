shared_examples_for 'a Plutus::Amount subtype' do |elements|
  let(:amount) { FactoryGirl.build(elements[:kind]) }
  subject { amount }

  it { is_expected.to  be_valid }

  it "should require an amount" do
    amount.amount = nil
    expect(amount).not_to be_valid
  end

  it "should require a entry" do
    amount.entry = nil
    expect(amount).not_to be_valid
  end

  it "should require an account" do
    amount.account = nil
    expect(amount).not_to be_valid
  end
end
