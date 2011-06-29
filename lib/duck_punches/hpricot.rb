
class Nokogiri::XML::NodeSet

  ##
  # Assume a Google standard money node with a currency attribute.
  #
  # Returns a Ruby Money object.
  
  def to_money
    dollar_amount = inner_html
    cents = (dollar_amount.to_f * 100).round
    currency = first[:currency]
    Money.new(cents, currency)    
  end

  ##
  # Return boolean true if the value of an element is the 
  # string 'true'.
  
  def to_boolean
    inner_html == 'true'
  end
  
end
