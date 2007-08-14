require 'rubygems'
require 'spec'
require File.dirname(__FILE__) + "/../lib/google-checkout"

def read_xml_fixture(filename)
  File.read(File.dirname(__FILE__) + "/fixtures/google/#{filename}.xml")
end

# A better +be_kind_of+ with more informative error messages.
#
# The default +be_kind_of+ just says 
#
#   "expected to return true but got false"
#
# This one says
#
#   "expected File but got Tempfile"

class BeKindOf
  
  def initialize(expected) # + args
    @expected = expected
  end

  def matches?(target)
    @target = target
    @target.kind_of?(@expected)
  end

  def failure_message
    "expected #{@expected} but got #{@target.class}"
  end

  def negative_failure_message
    "expected #{@expected} to not be #{@target.class}"
  end

  def description
    "be_kind_of #{@target}"
  end

end

def be_kind_of(expected) # + args
  BeKindOf.new(expected)
end

