google-checkout
    by Peter Elmore and Geoffrey Grosenbach
    http://rubyforge.org/projects/google-checkout

== DESCRIPTION:
  
Experimental library for working with GoogleCheckout. Currently in use for
payment at http://peepcode.com.

== Installation

  sudo gem install google-checkout
  
Or straight from the source at

  sudo gem install topfunky-google-checkout --source http://gems.github.com

== What is Google Checkout?

Well, according to Google, "Google Checkout helps you increase sales.  And
process them for free when you advertise with Google."  What it really amounts
to is that Google will process your orders for a 10% fee and you get a little
shopping cart icon in your ad if you advertise through AdWords.  The fee can
be paid by running AdWords ads on your site.  You can read about it and get an
account at http://checkout.google.com/sell.

== What is google-checkout?

google-checkout is a module for working with the Google Checkout API
(http://code.google.com/apis/checkout/index.html).  Specifically, if you have
a Google Checkout account, you can use this module to do things like add
"Checkout" and "Buy Now" buttons to your site.

== Brief Example

  require 'rubygems'
  require 'google-checkout'

  merchant_id = 'Your merchant id.'
  merchant_key = 'Your merchant key.  Keep this a secret!'

  cart = GoogleCheckout::Cart.new(merchant_id, merchant_key)
  cart.add_item(:name => 'Chair', :description => 'A sturdy, wooden chair',
                :price => 44.99)
  puts cart.checkout_button

== Usage

First, you'll need a merchant ID and a merchant key, which you can get from
the Google Checkout site once you have an account.  After you have that, you
can start writing code.  

The class you'll be working with is GoogleCheckout::Cart.  Of course, it
represents a cart, and you can fill it with items.  

  cart = GoogleCheckout::Cart.new(merchant_id, merchant_key, item1, item2)
  cart.add_item item3

The items you put into the cart should be one of two types:
* A Hash containing the following
** :name
** :description
** :price
** :quantity (default 1)
** :currency (default 'USD')
** :regular_shipping, the shipping cost (default $0)
* Or any Object that has a method called to_google_product that returns a hash
  like the one described.

Once you have a cart full of items, you can generate the XML for the API call
by calling Cart#checkout_xml, although you'll probably just want to add a
checkout button to your page with Cart#checkout_button.  This method generates
HTML for a form containing a button and the hidden inputs necessary to call
Google Checkout.  Cart#checkout_button has plenty of options for controlling
the look of the button.  Once again, the arguments are passed as a hash,
although the defaults are usually reasonable so you might not need to pass
anything.

* :size is the size of the button, one of :small, :medium, or :large.  Google
  is picky about the sizes of these buttons.  See GoogleCheckout::ButtonSizes
  for more information.  The default is :medium.
* :variant is one of 'disabled' or 'text'.  'disabled' means that the button 
  should be greyed-out; it is used in cases that the item you are selling
  cannot be bought via Google Checkout.  (There's a long list of items that
  are not allowed at https://checkout.google.com/seller/content_policies.html
* :buy_or_checkout must be one of :buy_now or :checkout .  This determines the
  look of the button that will be displayed.  The default is to use :checkout
  if there are two or more items in the cart.
* :style must be one of 'white' or 'trans'.  'white' gets you a white button,
  while 'trans' gets you a transparent button suitable for use on non-white
  backgrounds.  The default is 'white'.

  cart.checkout_button :size => :small, :style => 'trans'

When users click the button, they will be taken to the Google Checkout page
with a cart full of the products you specified, and your work is done.

== Missing Features

* Level 1 integration is complete except for tax tables
* Level 2 integration has been partly implemented and is in use at http://peepcode.com.  

See
http://checkout.google.com/support/sell/bin/answer.py?answer=42917&topic=8671
for more information about the two integration levels.

If there are missing features I haven't thought of, let me know.

== Bugs

No 'hard' bugs, I hope.  Pete's contact information is at the bottom of the page if you find one.  There may be more subjective bugs (e.g., design issues); feel free to tell me about these, too.

== Contact Information

The home page is at http://debu.gs/google-checkout .  You can email me at pete
dot elmore at gmail dot com.  Try to mention Google Checkout in the subject
line.

== LICENSE:

(The MIT License)

Copyright (c) 2006-2007 Peter Elmore (pete.elmore at gmail.com) and Topfunky Corporation

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

