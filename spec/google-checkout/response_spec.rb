require File.dirname(__FILE__) + "/../spec_helper"

# Responses

describe GoogleCheckout, "Checkout Redirect" do

  before(:each) do
    @response = GoogleCheckout::Notification.parse(read_xml_fixture('responses/checkout-redirect'))
  end

  it "should identify type of notification" do
    @response.should be_kind_of(GoogleCheckout::CheckoutRedirect)
  end

  it "should unescape url" do
    @response.redirect_url.should == 'https://checkout.google.com/buy?foo=bar&id=8572098456'
  end

end

describe GoogleCheckout, "Request Received" do

  before(:each) do
    @response = GoogleCheckout::Notification.parse(read_xml_fixture('responses/request-received'))
  end

  it "should identify type of notification" do
    @response.should be_kind_of(GoogleCheckout::RequestReceived)
  end

end

# Errors

describe GoogleCheckout, "Error" do

  before(:each) do
    @response = GoogleCheckout::Notification.parse(read_xml_fixture('responses/error'))
  end

  it "should identify type of notification" do
    @response.should be_kind_of(GoogleCheckout::Error)
  end

  it "should read error message" do
    @response.message.should == 'Bad username and/or password for API Access.'
  end

end
