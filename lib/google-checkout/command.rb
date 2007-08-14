
# TODO
#
#   * Use standard ssl certs

module GoogleCheckout

  ##
  # Abstract class for commands.
  #
  #  https://sandbox.google.com/checkout/cws/v2/Merchant/1234567890/request
  #  https://checkout.google.com/cws/v2/Merchant/1234567890/request

  class Command

    attr_accessor :merchant_id, :merchant_key, :currency

    SANDBOX_REQUEST_URL = "https://sandbox.google.com/checkout/cws/v2/Merchant/%s/request"
    PRODUCTION_REQUEST_URL = "https://checkout.google.com/cws/v2/Merchant/%s/request"

    def initialize(merchant_id, merchant_key)
      @merchant_id = merchant_id
      @merchant_key = merchant_key

      @currency = "USD"
    end

    ##
    # Returns the appropriate sandbox or production url for posting API requests.

    def url
      GoogleCheckout.sandbox? ? (SANDBOX_REQUEST_URL % @merchant_id) : (PRODUCTION_REQUEST_URL % @merchant_id)
    end

    ##
    # Sends the Command's XML to GoogleCheckout via HTTPS with Basic Auth.
    #
    # Returns a GoogleCheckout::RequestReceived or a GoogleCheckout::Error object.

    def post
      # Create HTTP(S) POST command and set up Basic Authentication.
      uri = URI.parse(url)

      request = Net::HTTP::Post.new(uri.path)
      request.basic_auth(@merchant_id, @merchant_key)

      # Set up the HTTP connection object and the SSL layer.
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.cert_store = self.class.x509_store
      https.verify_mode = OpenSSL::SSL::VERIFY_PEER
      https.verify_depth = 5

      # Send the request to Google.
      response = https.request(request, self.to_xml)

      # NOTE Because Notification.parse() is used, the content of objects
      #      will be correctly parsed no matter what the HTTP response code
      #      is from the server.
      case response
      when Net::HTTPSuccess, Net::HTTPClientError
        notification = Notification.parse(response.body)
        if notification.error?
          raise APIError, "#{notification.message} [in #{GoogleCheckout.production? ? 'production' : 'sandbox' }]"
        end
        return notification
      when Net::HTTPRedirection, Net::HTTPServerError, Net::HTTPInformation
        raise "Unexpected response code (#{response.class}): #{response.code} - #{response.message}"
      else
        raise "Unknown response code: #{response.code} - #{response.message}"
      end
    end

    ##
    # Class method to return the OpenSSL::X509::Store instance for the
    # CA certificates.
    #
    # NOTE May not be thread-safe.

    def self.x509_store
      return @@x509_store if defined?(@@x509_store)

      cacert_path = File.expand_path(File.dirname(__FILE__) + '/../../support/cacert.pem')

      @@x509_store = OpenSSL::X509::Store.new
      @@x509_store.add_file(cacert_path)

      return @@x509_store
    end

  end

  ##
  # Abstract class for all commands associated with an existing order.

  class OrderCommand < Command

    attr_accessor :google_order_number, :amount

    ##
    # Make a new object. Last argument is the Google's order number as received
    # in the NewOrderNotification.

    def initialize(merchant_id, merchant_key, google_order_number)
      # TODO raise "Not an order number!" unless google_order_number.is_a? String
      super(merchant_id, merchant_key)
      @google_order_number = google_order_number
      @amount = 0.00
    end

  end

  ##
  # Create a new ChargeOrder object, set the +amount+, then
  # +post+ it.

  class ChargeOrder < OrderCommand

    def to_xml
      raise "Charge amount must be greater than 0!" unless @amount.to_f > 0.0

      xml = Builder::XmlMarkup.new
      xml.instruct!
      @xml = xml.tag!('charge-order', {
        :xmlns => "http://checkout.google.com/schema/2",
        "google-order-number" => @google_order_number
      }) do
        xml.tag!("amount", @amount, {:currency => @currency})
      end
      @xml
    end

  end

  ##
  # Tells Google that the order has shipped.

  class DeliverOrder < OrderCommand

    def to_xml

      xml = Builder::XmlMarkup.new
      xml.instruct!
      @xml = xml.tag!('deliver-order', {
        :xmlns => "http://checkout.google.com/schema/2",
        "google-order-number" => @google_order_number
      }) do
        xml.tag!("send-email", false)
      end
      @xml
    end

  end

  ##
  # Send a message to the buyer associated with an order.
  #
  # Google will actually send the message to their email address.

  class SendBuyerMessage < OrderCommand

    ##
    # Make a new message to send.
    #
    # The last argument is the actual message.
    #
    # Call +post+ on the resulting object to submit it to Google for sending.

    def initialize(merchant_id, merchant_key, google_order_number, message)
      # TODO Raise meaninful error if message is longer than 255 characters
      raise "Google won't send anything longer than 255 characters! Sorry!" if message.length > 255
      @message = message
      super(merchant_id, merchant_key, google_order_number)
    end

    def to_xml # :nodoc:
      xml = Builder::XmlMarkup.new
      xml.instruct!
      @xml = xml.tag!('send-buyer-message', {
        :xmlns => "http://checkout.google.com/schema/2",
        "google-order-number" => @google_order_number
      }) do
        xml.tag!("message", @message)
        xml.tag!("send-email", true)
      end
      @xml
    end

  end

end
