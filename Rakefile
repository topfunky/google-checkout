require 'rubygems'
require 'isolate/now'
require 'hoe'

Hoe.plugin :doofus, :git, :isolate
Hoe.spec "google-checkout" do
  developer "Geoffrey Grosenbach", "boss@topfunky.com"

  #require_ruby_version ">= 1.8.7"
  
  #self.extra_rdoc_files = Dir["*.rdoc"]
  #self.history_file     = "CHANGELOG.rdoc"
  #self.readme_file      = "README.rdoc"
  self.testlib          = :rspec
  
  self.remote_rdoc_dir = '' # Release docs to root
end


# Hoe.plugin :isolate
# Hoe.new('google-checkout', GoogleCheckout::VERSION) do |p|
#   p.name = "google-checkout"
#   p.author = ["Peter Elmore", "Geoffrey Grosenbach"]
#   p.email = 'boss@topfunky.com'
#   p.summary = "An experimental library for sending payment requests to Google Checkout."
#   p.description = p.paragraphs_of('README.txt', 1..1).join("\n\n")
#   p.url = "http://rubyforge.org/projects/google-checkout"
#   p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
#   p.remote_rdoc_dir = '' # Release docs to root
# end

# desc "Run specs"
# task :default do
#   system 'spec spec --format specdoc --color'
# end
