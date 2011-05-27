
module GoogleCheckout

  # These are the only sizes allowed by Google.  These shouldn't be needed
  # by most people; just specify the :size and :buy_or_checkout options to
  # Cart#checkout_button and the sizes are filled in automatically.
  ButtonSizes = {
    :checkout => {
      :small => { :w => 160, :h => 43 },
      :medium => { :w => 168, :h => 44 },
      :large => { :w => 180, :h => 46 },
    },

    :buy_now => {
      :small => { :w => 117, :h => 48 },
      :medium => { :w => 121, :h => 44 },
      :large => { :w => 121, :h => 44 },
    },
  }

  ##
  # This class represents a cart for Google Checkout.  After initializing it
  # with a +merchant_id+ and +merchant_key+, you add items via add_item,
  # and can then get xml via to_xml, or html code for a form that
  # provides a checkout button via checkout_button.
  #
  # Example:
  #
  #   item = {
  #            :name => 'A Quarter',
  #            :description => 'One shiny quarter.',
  #            :price => 0.25
  #          }
  #   @cart = GoogleCheckout::Cart.new(merchant_id, merchant_key, item)
  #   @cart.add_item(:name => "Pancakes",
  #                  :description => "Flapjacks by mail."
  #                  :price => 0.50,
  #                  :quantity => 10,
  #                  "merchant-item-id" => '2938292839')
  #
  # Then in your view:
  #
  #   Checkout here! <%= @cart.checkout_button %>
  #
  # This object is also useful for getting back a url to the image for a Google
  # Checkout button. You can use this image in forms that submit back to your own
  # server for further processing via Google Checkout's level 2 XML API.

  class Cart < Command

    include GoogleCheckout

    SANDBOX_CHECKOUT_URL    = "https://sandbox.google.com/checkout/cws/v2/Merchant/%s/checkout"
    PRODUCTION_CHECKOUT_URL = "https://checkout.google.com/cws/v2/Merchant/%s/checkout"

    ##
    # You can provide extra data that will be sent to Google and returned with
    # the NewOrderNotification.
    #
    # This should be a Hash and will be turned into XML with proper escapes.
    #
    # Beware using symbols as values. They may be set as sub-keys instead of values,
    # so use a String or other datatype.

    attr_accessor :merchant_private_data

    attr_accessor :edit_cart_url
    attr_accessor :continue_shopping_url

    # The default options for drawing in the button that are filled in when
    # checkout_button or button_url is called.
    DefaultButtonOpts = {
      :size => :medium,
      :style => 'white',
      :variant => 'text',
      :loc => 'en_US',
      :buy_or_checkout => nil,
    }

    # You need to supply, as strings, the +merchant_id+ and +merchant_key+
    # used to identify your store to Google.  You may optionally supply one
    # or more items to put inside the cart.
    def initialize(merchant_id, merchant_key, *items)
      super(merchant_id, merchant_key)
      @contents = []
      @merchant_private_data = {}
      items.each { |i| add_item i }
    end


    # This method sets the flat rate shipping for the entire cart.
    # If set, it will over ride the per product flat rate shipping.
    # +frs_options+ should be a hash containing the following options:
    # * price
    # You may fill an some optional values as well:
    # * currency (defaults to 'USD')
    def flat_rate_shipping(frs_options)
      # We need to check that the necessary keys are in the hash,
      # Otherwise the error will happen in the middle of to_xml,
      # and the bug will be harder to track.
      unless frs_options.include? :price
        raise ArgumentError,
        "Required keys missing: :price"
      end

      @flat_rate_shipping = {:currency => 'USD'}.merge(frs_options)
    end

    def empty?
      @contents.empty?
    end

    # Number of items in the cart.
    def size
      @contents.size
    end

    def submit_domain
      (GoogleCheckout.production? ? 'checkout' : 'sandbox') + ".google.com"
    end

    ##
    # The Google Checkout form submission url.

    def submit_url
      GoogleCheckout.sandbox? ? (SANDBOX_CHECKOUT_URL % @merchant_id) : (PRODUCTION_CHECKOUT_URL % @merchant_id)
    end

    # This method puts items in the cart.
    # +item+ may be a hash, or have a method named +to_google_product+ that
    # returns a hash with the required values.
    # * name
    # * description (a brief description as it will appear on the bill)
    # * price
    # You may fill in some optional values as well:
    # * quantity (defaults to 1)
    # * currency (defaults to 'USD')
    def add_item(item)
      @xml = nil
      if item.respond_to? :to_google_product
        item = item.to_google_product
      end

      # We need to check that the necessary keys are in the hash,
      # Otherwise the error will happen in the middle of to_xml,
      # and the bug will be harder to track.
      missing_keys = [ :name, :description, :price ].select { |key|
        !item.include? key
      }

      unless missing_keys.empty?
        raise ArgumentError,
        "Required keys missing: #{missing_keys.inspect}"
      end

      @contents << { :quantity => 1, :currency => 'USD' }.merge(item)
      item
    end

    # Remove an item
    def remove_item(index)
      @contents.delete_at(index)
      @xml = nil
    end

    # expose the XML
    def xml
      @xml
    end

    # expose the contents
    def contents
      @contents
    end

    # This is the important method; it generatest the XML call.
    # It's fairly lengthy, but trivial.  It follows the docs at
    # http://code.google.com/apis/checkout/developer/index.html#checkout_api
    #
    # It returns the raw XML string, not encoded.
    def to_xml
      raise RuntimeError, "Empty cart" if self.empty?

      xml = Builder::XmlMarkup.new
      xml.instruct!
      @xml = xml.tag!('checkout-shopping-cart', :xmlns => "http://checkout.google.com/schema/2") {
        xml.tag!("shopping-cart") {
          xml.items {
            @contents.each { |item|
              xml.item {
                if item.key?(:item_id)
                  xml.tag!('merchant-item-id', item[:item_id])
                end
                if item.key?(:weight)
                  xml.tag!('item-weight', :unit => "LB", :value => item[:weight])
                end
                xml.tag!('item-name') {
                  xml.text! item[:name].to_s
                }
                xml.tag!('item-description') {
                  xml.text! item[:description].to_s
                }
                xml.tag!('unit-price', :currency => (item[:currency] || 'USD')) {
                  xml.text! item[:price].to_s
                }
                xml.quantity {
                  xml.text! item[:quantity].to_s
                }
              }
            }
          }
          unless @merchant_private_data.empty?
            xml.tag!("merchant-private-data") {
              @merchant_private_data.each do |key, value|
                xml.tag!(key, value)
              end
            }
          end
        }
        xml.tag!('checkout-flow-support') {
          xml.tag!('merchant-checkout-flow-support') {
            xml.tag!('edit-cart-url', @edit_cart_url) if @edit_cart_url
            xml.tag!('continue-shopping-url', @continue_shopping_url) if @continue_shopping_url

            xml.tag!("request-buyer-phone-number", false)

            # TODO tax-tables
            xml.tag!("tax-tables") {
              xml.tag!("default-tax-table") {
                xml.tag!("tax-rules") {
                  xml.tag!("default-tax-rule") {
                    xml.tag!("shipping-taxed", false)
                    xml.tag!("rate", "0.00")
                    xml.tag!("tax-area") {
                      xml.tag!("world-area")
                    }
                  }
                }
              }
            }

            # TODO Shipping calculations
            #      These are currently hard-coded for PeepCode.
            #      Does anyone care to send a patch to enhance
            #      this for more flexibility?
            xml.tag!('shipping-methods') {
              if (@shipping)
                xml.tag!('carrier-calculated-shipping') {
                  xml.tag!('carrier-calculated-shipping-options') {
                    xml.tag!('carrier-calculated-shipping-option') {
                      xml.tag!('shipping-company') {
                        xml.text! @shipping[:shipping_company]
                      }
                      xml.tag!('shipping-type') {
                        xml.text! @shipping[:shipping_type]
                      }
                      xml.tag!('price', :currency => currency) {
                        xml.text! @shipping[:price]
                      }
                      if @shipping[:additional_fixed_charge]
                        xml.tag!('additional-fixed-charge', :currency => currency) {
                          xml.text! @shipping[:additional_fixed_charge]
                        }
                      end
                      if @shipping[:additional_variable_charge_percent]
                        xml.tag!('additional-variable-charge-percent') {
                          xml.text! @shipping[:additional_variable_charge_percent]
                        }
                      end
                    }
                  }
                  xml.tag!('shipping-packages') {
                    xml.tag!('shipping-package') {
                      xml.tag!('ship-from', :id => "id") {
                        xml.tag!('city') {
                          xml.text! @shipping[:city]
                        }
                        xml.tag!('region') {
                          xml.text! @shipping[:region]
                        }
                        xml.tag!('postal-code') {
                          xml.text! @shipping[:postal_code]
                        }
                        xml.tag!('country-code') {
                          xml.text! @shipping[:country_code]
                        }
                      }
                    }
                  }
                }
              else
                xml.tag!('pickup', :name =>'Digital Download') {
                  xml.tag!('price', "0.00", :currency => currency)
                }
              end
            }
          }
        }
      }
      @xml.dup
    end

    # Fill up the @shipping object
    # See http://code.google.com/apis/checkout/developer/Google_Checkout_XML_API_Carrier_Calculated_Shipping.html
    # Options, with sample values, are:
    #   Required:
    #     :shipping_company => "UPS"
    #     :shipping_type => "Ground"
    #     :city => "Seattle"
    #     :region => "WA"
    #     :postal_code => "98117"
    #     :country_code => "US"
    #     :price => 200
    #   Optional:
    #     :additional_fixed_charge => 10
    #     :additional_variable_charge_percent => 5
    def shipping_options(options={})
      @shipping = options
    end

    def shipping
      @shipping
    end

    # Generates the XML for the shipping cost, conditional on
    # @flat_rate_shipping being set.
    def shipping_cost_xml
      xml = Builder::XmlMarkup.new
      if @flat_rate_shipping
        xml.price(:currency => currency) {
          xml.text! @flat_rate_shipping[:price].to_s
        }
      else
        xml.price(:currency => @currency) {
          xml.text! shipping_cost.to_s
        }
      end
    end

    # Returns the shipping cost for the contents of the cart.
    def shipping_cost
      currency = 'USD'
      shipping = @contents.inject(0) { |total,item|
        total + item[:regular_shipping].to_i
      }.to_s
    end

    # Returns the currency for the cart.  Mixing currency not allowed; this
    # library can't convert between currencies.
    def currency
      # Mixing currency not allowed; this
      # library can't convert between
      # currencies.
      @currency ||=
        (@contents.map { |item|
           item.currency
         }.uniq.first rescue nil) ||
        'USD'
    end

    # Returns the signature for the cart XML.
    def signature
      @xml or to_xml

      digest  = OpenSSL::Digest::Digest.new('sha1')
      OpenSSL::HMAC.digest(digest, @merchant_key, @xml)
    end

    # Returns HTML for a checkout form for buying all the items in the
    # cart.
    def checkout_button(button_opts = {})
      @xml or to_xml
      burl = button_url(button_opts)
      html = Builder::XmlMarkup.new(:indent => 2)
      html.form({
                  :action => submit_url,
                  :style => 'border: 0;',
                  :id => 'BB_BuyButtonForm',
                  :method => 'post',
                  :name => 'BB_BuyButtonForm'
                }) do
        html.input({
                     :name => 'cart',
                     :type => 'hidden',
                     :value => Base64.encode64(@xml).gsub("\n", '')
                   })
        html.input({
                     :name => 'signature',
                     :type => 'hidden',
                     :value => Base64.encode64(signature).gsub("\n", '')
                   })
        html.input({
                     :alt => 'Google Checkout',
                     :style => "width: auto;",
                     :src => button_url(button_opts),
                     :type => 'image'
                   })
      end
    end

    # Given a set of options for the button, button_url returns the URL
    # for the button image.
    # The options are the same as those specified on
    # http://checkout.google.com/seller/checkout_buttons.html , with a
    # couple of extra options for convenience.  Rather than specifying the
    # width and height manually, you may specify :size to be one of :small,
    # :medium, or :large, and that you may set :buy_or_checkout to :buy_now
    # or :checkout to get a 'Buy Now' button versus a 'Checkout' button. If
    # you don't specify :buy_or_checkout, the Cart will try to guess based
    # on if the cart has more than one item in it.  Whatever you don't pass
    # will be filled in with the defaults from DefaultButtonOpts.
    #
    #   http://checkout.google.com/buttons/checkout.gif
    #   http://sandbox.google.com/checkout/buttons/checkout.gif

    def button_url(opts = {})
      opts = DefaultButtonOpts.merge opts
      opts[:buy_or_checkout] ||= @contents.size > 1 ? :checkout : :buy_now
      opts.merge! ButtonSizes[opts[:buy_or_checkout]][opts[:size]]
      bname = opts[:buy_or_checkout] == :buy_now ? 'buy.gif' : 'checkout.gif'
      opts.delete :size
      opts.delete :buy_or_checkout
      opts[:merchant_id] = @merchant_id

      path = opts.map { |k,v| "#{k}=#{v}" }.join('&')

      # HACK Sandbox graphics are in the checkout subdirectory
      subdir = ""
      if GoogleCheckout.sandbox? && bname == "checkout.gif"
        subdir = "checkout/"
      end

      # TODO Use /checkout/buttons/checkout.gif if in sandbox.
      "http://#{submit_domain}/#{ subdir }buttons/#{bname}?#{path}"
    end
  end

end
