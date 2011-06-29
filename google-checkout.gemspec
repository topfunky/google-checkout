Gem::Specification.new do |s|
  s.name = %q{google-checkout}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Geoffrey Grosenbach"]
  s.date = %q{2011-02-08}
  s.description = %q{Experimental library for working with GoogleCheckout. Currently in use for payment at http://peepcode.com.}
  s.email = ["boss@topfunky.com"]
  s.extra_rdoc_files = ["History.txt", "MIT-LICENSE.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Isolate", "MIT-LICENSE.txt", "Manifest.txt", "README.txt", "Rakefile", "examples/google_notifications_controller.rb", "lib/duck_punches/hpricot.rb", "lib/google-checkout.rb", "lib/google-checkout/cart.rb", "lib/google-checkout/command.rb", "lib/google-checkout/notification.rb", "spec/fixtures/google/checkout-shopping-cart.xml", "spec/fixtures/google/commands/add-merchant-order-number.xml", "spec/fixtures/google/commands/add-tracking-data.xml", "spec/fixtures/google/commands/archive-order.xml", "spec/fixtures/google/commands/authorize-order.xml", "spec/fixtures/google/commands/cancel-order.xml", "spec/fixtures/google/commands/charge-order.xml", "spec/fixtures/google/commands/deliver-order.xml", "spec/fixtures/google/commands/process-order.xml", "spec/fixtures/google/commands/refund-order.xml", "spec/fixtures/google/commands/send-buyer-message.xml", "spec/fixtures/google/commands/unarchive-order.xml", "spec/fixtures/google/notifications/authorization-amount-notification.xml", "spec/fixtures/google/notifications/charge-amount-notification.xml", "spec/fixtures/google/notifications/chargeback-amount-notification.xml", "spec/fixtures/google/notifications/new-order-notification.xml", "spec/fixtures/google/notifications/order-state-change-notification.xml", "spec/fixtures/google/notifications/refund-amount-notification.xml", "spec/fixtures/google/notifications/risk-information-notification.xml", "spec/fixtures/google/responses/checkout-redirect.xml", "spec/fixtures/google/responses/error.xml", "spec/fixtures/google/responses/request-received.xml", "spec/google-checkout/cart_spec.rb", "spec/google-checkout/command_spec.rb", "spec/google-checkout/notification_spec.rb", "spec/google-checkout/response_spec.rb", "spec/google-checkout_spec.rb", "spec/spec_helper.rb", "support/cacert.pem"]
  s.homepage = %q{http://github.com/topfunky/google-checkout}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{google-checkout}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Experimental library for working with GoogleCheckout}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_runtime_dependency(%q<money>, [">= 3.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<hoe>, ["= 2.8"])
      s.add_development_dependency(%q<hoe-doofus>, ["= 1.0.0"])
      s.add_development_dependency(%q<hoe-git>, ["= 1.3.0"])
      s.add_development_dependency(%q<rspec>, ["= 1.3.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.8.0"])
    else
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<money>, [">= 3.0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<hoe>, ["= 2.8"])
      s.add_dependency(%q<hoe-doofus>, ["= 1.0.0"])
      s.add_dependency(%q<hoe-git>, ["= 1.3.0"])
      s.add_dependency(%q<rspec>, ["= 1.3.0"])
      s.add_dependency(%q<hoe>, [">= 2.8.0"])
    end
  else
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<money>, [">= 3.0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<hoe>, ["= 2.8"])
    s.add_dependency(%q<hoe-doofus>, ["= 1.0.0"])
    s.add_dependency(%q<hoe-git>, ["= 1.3.0"])
    s.add_dependency(%q<rspec>, ["= 1.3.0"])
    s.add_dependency(%q<hoe>, [">= 2.8.0"])
  end
end
