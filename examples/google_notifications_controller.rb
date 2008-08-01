##
# Skeleton for handing Level 2 notifications from GoogleCheckout with Rails.
#
# You'll need to write the individual handlers. SSL is required.
#
# SAMPLE ONLY! Modify for your own use. Extra error handling may be needed.

class GoogleNotificationsController < ApplicationController

  before_filter :verify_access
  after_filter  :log_google_notification

  ##
  # Google calls this with notifications.

  def create
    @notification = GoogleCheckout::Notification.parse(request.raw_post)

    case @notification
    when GoogleCheckout::NewOrderNotification
      handle_new_order_notification(@notification)

    when GoogleCheckout::OrderStateChangeNotification
      handle_order_state_change_notification(@notification)

    when GoogleCheckout::RiskInformationNotification
      handle_risk_information_notification(@notification)

    when GoogleCheckout::ChargeAmountNotification
      handle_charge_amount_notification(@notification)

    when GoogleCheckout::AuthorizationAmountNotification
      handle_authorization_amount_notification(@notification)

    when GoogleCheckout::ChargebackAmountNotification
      handle_chargeback_amount_notification(@notification)

    when GoogleCheckout::RefundAmountNotification
      handle_refund_amount_notification(@notification)
    end

    render :xml => @notification.acknowledgment_xml
  end

  private

  ##
  # Use basic authentication in my realm to get a user object.
  # Since this is a security filter - return false if the user is not authenticated.

  def verify_access
    return false unless (request.ssl? || (RAILS_ENV == 'development') || (RAILS_ENV == 'test'))
    authenticate_or_request_with_http_basic("PeepCode") do |merchant_id, merchant_key|
      (merchant_id == GOOGLE_ID) && (merchant_key == GOOGLE_KEY)
    end
  end

  ##
  #

  def log_google_notification
    # TODO Write to your log or to a DB table
  end

  ##
  #

  def handle_new_order_notification(notification)
    logger.info "Got NewOrderNotification"

    # NOTE You should have passed your own order number to Google when
    #      making the initial order. Subsequent notifications will use
    #      Google's order number instead.
    @order = Order.find_by_order_number(notification.my_order_number)
    if @order
      # NOTE You may want to check the amount being charged vs. the amount
      #      you expected the user to pay.

      @order.google_order_number = notification.google_order_number
      @order.email  = notification.email

      # Fee is 20 cents plus 2% of total.
      @order.fee_cents   = (20 + (notification.order_total.cents * 0.02)).round
      @order.gross_cents = notification.order_total.cents
      @order.net_cents   = @order.gross_cents - @order.fee_cents

      # NOTE Also of interest is notification.email_allowed, a boolean
      @order.save
      @order.new_order!
    end
  end

  ##
  #

  def handle_order_state_change_notification(notification)
    @order = Order.find_for_notification(notification)
    @order.update_attribute(:google_state, notification.state)

    case notification.state
    when "REVIEWING"            # Initial state of orders. Rarely seen by client.

    when "CHARGEABLE"           # You can now charge the customer for the order.
      @order.chargeable!
    when "CHARGING"             # Google is charging the customer.
      @order.charging!
    when "CHARGED"              # You have charged the customer.
      @order.charged!
    when "PAYMENT_DECLINED"     # Google was unable to charge the client
      @order.denied!
    when "CANCELLED"            # Order was cancelled by the merchant
      @order.denied!
      @order.update_attribute(:payment_note, notification.reason) rescue nil
    when "CANCELLED_BY_GOOGLE"  # Order was cancelled by Google
      @order.denied!
      # notification.reason
    end
  end

  ##
  #

  def handle_risk_information_notification(notification)
    logger.info "Got RiskInformationNotification"

    @order = Order.find_for_notification(notification)
    @order.risk!

    # TODO You need to ping Google after this to trigger the next state.
    #      Do this in the model, but for reference, here's the basic code.
    if @order.google_state == "CHARGEABLE"
      charge_order_command = GoogleCheckout::ChargeOrder.new(GOOGLE_ID, GOOGLE_KEY, @order.google_order_number)
      # To string, to float in order to get a float representation of the money
      charge_order_command.amount = total_price.to_s.to_f
      # Will throw error on failure
      notification = charge_order_command.post
    else
      logger.error("Order was not in CHARGEABLE state")
    end
  end

  ##
  #

  def handle_charge_amount_notification(notification)
    @order = Order.find_for_notification(notification)
    @order.charge!
  end

  ##
  #

  def handle_refund_amount_notification(notification)
    # NOTE Notification includes amount refunded.
    @order = Order.find_for_notification(notification)
    @order.refund!
  end

end
