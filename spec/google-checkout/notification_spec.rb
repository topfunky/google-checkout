require File.dirname(__FILE__) + "/../spec_helper"

describe "basic notification", :shared => true do

  it "should get serial number" do
    @notification.serial_number.should == 'bea6bc1b-e1e2-44fe-80ff-0180e33a2614'
  end

  it "should get google order number" do
    @notification.google_order_number.should == '841171949013218'
  end

  it "should generate acknowledgment XML" do
    @notification.acknowledgment_xml.should match(/notification-acknowledgment/)
  end

end

describe GoogleCheckout, "New Order Notification" do

  before(:each) do
    @notification = GoogleCheckout::Notification.parse(read_xml_fixture('notifications/new-order-notification'))
  end

  it "should identify type of notification" do
    @notification.should be_kind_of(GoogleCheckout::NewOrderNotification)
  end

  it_should_behave_like "basic notification"

  it "should find fulfillment order state" do
    @notification.fulfillment_order_state.should == 'NEW'
  end

  it "should find financial order state" do
    @notification.financial_order_state.should == 'REVIEWING'
  end

  it "should use financial state shortcut" do
    @notification.state.should == "REVIEWING"
  end

  it "should create Money object from order total" do
    @notification.order_total.should be_kind_of(Money)
    @notification.order_total.cents.should == 19098
    @notification.order_total.currency.iso_code.should == 'USD'
  end

  it "should throw error when accessing non-existent value" do
    lambda { @notification.there_is_no_field_with_this_name }.should raise_error(NoMethodError)
  end

  it "should find sub-keys of merchant-private-data as if they were at the root" do
    @notification.peepcode_order_number.should == '1234-5678-9012'
  end

  it "should find total tax" do
    @notification.total_tax.should be_kind_of(Money)
    @notification.total_tax.cents.should == 0
  end

  it "should find email marketing allowed" do
    @notification.email_allowed.should be_false
  end

  it "should get email or buyer-shipping-address/email or buyer-billing-address/email"

end


describe GoogleCheckout, "Order State Change Notification" do

  before(:each) do
    @notification = GoogleCheckout::Notification.parse(read_xml_fixture('notifications/order-state-change-notification'))
  end

  it_should_behave_like "basic notification"

  it "should identify type of notification" do
    @notification.should be_kind_of(GoogleCheckout::OrderStateChangeNotification)
  end

  it "should find new financial state" do
    @notification.new_financial_order_state.should == 'CHARGING'
  end

  it "should find new fulfillment state" do
    @notification.new_fulfillment_order_state.should == 'NEW'
  end

  it "should use financial state shortcut" do
    @notification.state.should == 'CHARGING'
  end

end

describe GoogleCheckout, "Risk Information Notification" do

  before(:each) do
    @notification = GoogleCheckout::Notification.parse(read_xml_fixture('notifications/risk-information-notification'))
  end

  it "should identify type of notification" do
    @notification.should be_kind_of(GoogleCheckout::RiskInformationNotification)
  end

  it_should_behave_like "basic notification"

end

describe GoogleCheckout, "Charge Amount Notification" do

  before(:each) do
    @notification = GoogleCheckout::Notification.parse(read_xml_fixture('notifications/charge-amount-notification'))
  end

  it_should_behave_like "basic notification"

  it "should identify type of notification" do
    @notification.should be_kind_of(GoogleCheckout::ChargeAmountNotification)
  end

  it "should get latest charge amount" do
    @notification.latest_charge_amount.should be_kind_of(Money)
  end

  it "should get total charge amount" do
    @notification.total_charge_amount.should be_kind_of(Money)
    @notification.total_charge_amount.cents.should == 22606
  end

end

describe GoogleCheckout, "Authorization Amount Notification" do

  before(:each) do
    @notification = GoogleCheckout::Notification.parse(read_xml_fixture('notifications/authorization-amount-notification'))
  end

  it_should_behave_like "basic notification"

  it "should identify type of notification" do
    @notification.should be_kind_of(GoogleCheckout::AuthorizationAmountNotification)
  end

end

describe GoogleCheckout, "Chargeback Amount Notification" do

  before(:each) do
    @notification = GoogleCheckout::Notification.parse(read_xml_fixture('notifications/chargeback-amount-notification'))
  end

  it_should_behave_like "basic notification"

  it "identifies type of notification" do
    @notification.should be_kind_of(GoogleCheckout::ChargebackAmountNotification)
  end

  it "parses chargeback amounts as money objects" do
    @notification.latest_chargeback_amount.cents.should == 22606
    @notification.total_chargeback_amount.cents.should == 22606
    @notification.latest_chargeback_amount.currency.iso_code.should == "USD"
  end

end

describe GoogleCheckout, "Refund Amount Notification" do

  before(:each) do
    @notification = GoogleCheckout::Notification.parse(read_xml_fixture('notifications/refund-amount-notification'))
  end

  it_should_behave_like "basic notification"

  it "should identify type of notification" do
    @notification.should be_kind_of(GoogleCheckout::RefundAmountNotification)
  end

end

