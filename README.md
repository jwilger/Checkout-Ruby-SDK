# REST API SDK for Ruby V2

![Home Image](homepage.jpg)

__Welcome to PayPal Ruby SDK__. This repository contains PayPal's Ruby SDK and samples for REST API.

This is a part of the next major PayPal SDK. It includes a simplified interface to only provide simple model objects and blueprints for HTTP calls. This repo currently contains functionality for PayPal Checkout APIs which includes Orders V2 and Payments V2.

## Please Note
> **The Payment Card Industry (PCI) Council has [mandated](http://blog.pcisecuritystandards.org/migrating-from-ssl-and-early-tls) that early versions of TLS be retired from service.  All organizations that handle credit card information are required to comply with this standard. As part of this obligation, PayPal is updating its services to require TLS 1.2 for all HTTPS connections. At this time, PayPal will also require HTTP/1.1 for all connections. [Click here](https://github.com/paypal/tls-update) for more information. Connections to the sandbox environment use only TLS 1.2.**

## Direct Credit Card Support
> **Important: The PayPal REST API no longer supports new direct credit card integrations.**  Please instead consider [Braintree Direct](https://www.braintreepayments.com/products/braintree-direct); which is, PayPal's preferred integration solution for accepting direct credit card payments in your mobile app or website. Braintree, a PayPal service, is the easiest way to accept credit cards, PayPal, and many other payment methods.

## Prerequisites

- Ruby 2.0.0 or above
- Bundler

## Usage

### Setting up credentials
Get client ID and client secret by going to https://developer.paypal.com/developer/applications and generating a REST API app. Get <b>Client ID</b> and <b>Secret</b> from there.

```ruby
require 'paypal-checkout-sdk'


# Creating Access Token for Sandbox
client_id = "AVNCVvV9oQ7qee5O8OW4LSngEeU1dI7lJAGCk91E_bjrXF2LXB2TK2ICXQuGtpcYSqs4mz1BMNQWuso1"
client_secret = "EDQzd81k-1z2thZw6typSPOTEjxC_QbJh6IithFQuXdRFc7BjVht5rQapPiTaFt5RC-HCa1ir6mi-H5l"
# Creating an environment
environment = CheckoutSdk::SandboxEnvironment.new(client_id, client_secret)
client = CheckoutSdk::PayPalHttpClient.new(self.environment)
```

## Examples

### Creating an Order

#### Code: 
```ruby

# Construct a request object and set desired parameters
# Here, OrdersCreateRequest::new creates a POST request to /v2/checkout/orders
request = CheckoutSdk::Orders::OrdersCreateRequest::new
request.request_body({
                        intent: "CAPTURE",
                        purchase_units: [
                            {
                                amount: {
                                    currency_code: "USD",
                                    value: "100.00"
                                }
                            }
                        ]
                      })

begin
    # Call API with your client and get a response for your call
    response = client.execute(request) 
    
    # If call returns body in response, you can get the deserialized version from the result attribute of the response
    order = response.result
    puts order
rescue BraintreeHttp::HttpError => ioe
    # Something went wrong server-side
    puts ioe.status_code
    puts ioe.headers["debug_id"]
end
```

#### Example Output:
```
Status Code:  201
Status:  CREATED
Order ID:  7F845507FB875171H
Intent:  CAPTURE
Links:
	self: https://api.sandbox.paypal.com/v2/checkout/orders/7F845507FB875171H	Call Type: GET
	approve: https://www.sandbox.paypal.com/checkoutnow?token=7F845507FB875171H	Call Type: GET
	authorize: https://api.sandbox.paypal.com/v2/checkout/orders/7F845507FB875171H/authorize	Call Type: POST
Gross Amount: USD 230.00
```

### Capturing an Order
After approving order above using `approve` link

#### Code:
```ruby
# Here, OrdersCaptureRequest::new() creates a POST request to /v2/checkout/orders
# order.id gives the orderId of the order created above
request = CheckoutSdk::Orders::OrdersCaptureRequest::new(order.id)

begin
    # Call API with your client and get a response for your call
    response = client.execute(request) 
    
    # If call returns body in response, you can get the deserialized version from the result attribute of the response
    order = response.result
    puts order
rescue BraintreeHttp::HttpError => ioe
    # Something went wrong server-side
    puts ioe.status_code
    puts ioe.headers["debug_id"]
end
```

#### Example Output:
```
Status Code:  201
Status:  COMPLETED
Order ID:  7F845507FB875171H
Links: 
	self: https://api.sandbox.paypal.com/v2/checkout/orders/70779998U8897342J	Call Type: GET
Buyer:
	Email Address: ganeshramc-buyer@live.com
	Name: test buyer
	Phone Number: 408-411-2134
```

## Running tests

To run integration tests using your client id and secret, clone this repository and run the following command:
```sh
$ bundle install
$ rspec spec
```

*NOTE*: This SDK is still in beta, is subject to change, and should not be used in production.

## Samples

You can start off by trying out [creating and capturing an order](/samples/capture_intent_examples/run_all.rb)

To try out different samples for both create and authorize intent check [this link](/samples)
