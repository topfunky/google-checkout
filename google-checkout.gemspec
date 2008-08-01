Gem::Specification.new do |s|
  s.name = %q{google-checkout}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter Elmore", "Geoffrey Grosenbach"]
  s.date = %q{2008-07-31}
  s.description = %q{== DESCRIPTION:  Experimental library for working with GoogleCheckout. Currently in use for payment at http://peepcode.com.}
  s.email = %q{boss@topfunky.com}
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt", "MIT-LICENSE.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/duck_punches/hpricot.rb", "lib/google-checkout.rb", "lib/google-checkout/cart.rb", "lib/google-checkout/command.rb", "lib/google-checkout/notification.rb", "spec/fixtures/google/checkout-shopping-cart.xml", "spec/fixtures/google/commands/add-merchant-order-number.xml", "spec/fixtures/google/commands/add-tracking-data.xml", "spec/fixtures/google/commands/archive-order.xml", "spec/fixtures/google/commands/authorize-order.xml", "spec/fixtures/google/commands/cancel-order.xml", "spec/fixtures/google/commands/charge-order.xml", "spec/fixtures/google/commands/deliver-order.xml", "spec/fixtures/google/commands/process-order.xml", "spec/fixtures/google/commands/refund-order.xml", "spec/fixtures/google/commands/send-buyer-message.xml", "spec/fixtures/google/commands/unarchive-order.xml", "spec/fixtures/google/notifications/authorization-amount-notification.xml", "spec/fixtures/google/notifications/charge-amount-notification.xml", "spec/fixtures/google/notifications/chargeback-amount-notification.xml", "spec/fixtures/google/notifications/new-order-notification.xml", "spec/fixtures/google/notifications/order-state-change-notification.xml", "spec/fixtures/google/notifications/refund-amount-notification.xml", "spec/fixtures/google/notifications/risk-information-notification.xml", "spec/fixtures/google/responses/checkout-redirect.xml", "spec/fixtures/google/responses/error.xml", "spec/fixtures/google/responses/request-received.xml", "spec/google-checkout/cart_spec.rb", "spec/google-checkout/command_spec.rb", "spec/google-checkout/notification_spec.rb", "spec/google-checkout/response_spec.rb", "spec/google-checkout_spec.rb", "spec/spec_helper.rb", "support/cacert.pem", "examples/google_notifications_controller.rb", "MIT-LICENSE.txt"]
  s.has_rdoc = true
  s.homepage = %q{http://rubyforge.org/projects/google-checkout}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{google-checkout}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{An experimental library for sending payment requests to Google Checkout.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<ruby-hmac>, [">= 0"])
      s.add_runtime_dependency(%q<hoe>, [">= 1.5.3"])
    else
      s.add_dependency(%q<ruby-hmac>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 1.5.3"])
    end
  else
    s.add_dependency(%q<ruby-hmac>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 1.5.3"])
  end
end
