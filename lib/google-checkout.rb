##
# Ref:
#
#  https://sandbox.google.com/checkout/cws/v2/Merchant/MERCHANT_ID/merchantCheckout
#  https://checkout.google.com/cws/v2/Merchant/MERCHANT_ID/merchantCheckout

$: << File.dirname(__FILE__)
$: << File.dirname(__FILE__) + "/vendor/ruby-hmac/lib"

require 'rubygems'

require 'openssl'
require 'base64'
require 'builder/xmlmarkup'
require 'hpricot'
require 'money'
require 'net/https'
require 'active_support'

require 'duck_punches/hpricot'
require 'google-checkout/notification'
require 'google-checkout/command'
require 'google-checkout/cart'

##
# TODO
# 
#   * Analytics integration
#     http://code.google.com/apis/checkout/developer/checkout_analytics_integration.html

module GoogleCheckout

  VERSION = '0.3.0'

  @@live_system = true
  
  ##
  # Submit commands to the Google Checkout test servers.
  
  def self.use_sandbox
    @@live_system = false
  end
  
  ##
  # The default.
  
  def self.use_production
    @@live_system = true
  end

  def self.sandbox?
    !@@live_system
  end

  def self.production?
    @@live_system
  end

  class APIError < Exception; end

end
