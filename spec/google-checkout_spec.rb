require File.dirname(__FILE__) + "/spec_helper"

describe GoogleCheckout do

  it "should use sandbox if set" do
    GoogleCheckout.use_sandbox
    GoogleCheckout.should be_sandbox
  end

  it "should not use sandbox if set to production" do
    GoogleCheckout.use_production
    GoogleCheckout.should_not be_sandbox
  end

end
