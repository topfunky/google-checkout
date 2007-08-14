require 'rubygems'
require 'hoe'
$:.unshift(File.dirname(__FILE__) + "/lib")
require 'google-checkout'

Hoe.new('google-checkout', GoogleCheckout::VERSION) do |p|
  p.name = "google-checkout"
  p.author = ["Peter Elmore", "Geoffrey Grosenbach"]
  p.email = 'boss@topfunky.com'
  p.summary = "An experimental library for sending payment requests to Google Checkout."
  p.description = p.paragraphs_of('README.txt', 1..1).join("\n\n")
  p.url = "http://rubyforge.org/projects/google-checkout"
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.remote_rdoc_dir = '' # Release docs to root
  p.extra_deps = ['ruby-hmac']
end

desc "Run specs"
task :default do
  system 'spec spec --format specdoc --color'
end
