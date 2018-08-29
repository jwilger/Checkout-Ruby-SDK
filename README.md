# REST API SDK for Ruby V2

![Home Image](homepage.jpg)

__Welcome to PayPal Python SDK__. This repository contains PayPal's Python SDK and samples for REST API.

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
from checkoutsdk.core import PayPalHttpClient, SandboxEnvironment


# Creating Access Token for Sandbox
client_id = "AVNCVvV9oQ7qee5O8OW4LSngEeU1dI7lJAGCk91E_bjrXF2LXB2TK2ICXQuGtpcYSqs4mz1BMNQWuso1"
client_secret = "EDQzd81k-1z2thZw6typSPOTEjxC_QbJh6IithFQuXdRFc7BjVht5rQapPiTaFt5RC-HCa1ir6mi-H5l"
# Creating an environment
environment = SandboxEnvironment(client_id=client_id, client_secret=client_secret)
client = PayPalHttpClient(environment)
```

## Examples

### Creating an Order

#### Code: 
```python
from checkoutsdk.orders import OrdersCreateRequest
# Construct a request object and set desired parameters
# Here, OrdersCreateRequest() creates a POST request to /v2/checkout/orders
request = OrdersCreateRequest()
request.request_body = ({
                            "intent": "CAPTURE",
                            "purchase_units": [
                                {
                                    "amount": {
                                        "currency_code": "USD",
                                        "value": "100.00"
                                    }
                                }
                            ]
                        })

try:
    # Call API with your client and get a response for your call
    response = client.execute(request) 
    
    # If call returns body in response, you can get the deserialized version from the result attribute of the response
    order = response.result
    print response.result
except IOError as ioe:
    if isinstance(ioe, HttpError):
        # Something went wrong server-side
        print ioe.status_code
        print ioe.headers["debug_id"]
    else:
        # Something went wrong client side
        print ioe
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
```python
from checkoutsdk.orders import OrdersCaptureRequest
# Here, OrdersCaptureRequest() creates a POST request to /v2/checkout/orders
# order.id gives the orderId of the order created above
request = OrdersCaptureRequest(order.id)

try:
    # Call API with your client and get a response for your call
    response = client.execute(request)
    
    # If call returns body in response, you can get the deserialized version from the result attribute of the response
    order = response.result
except IOError as ioe:
    if isinstance(ioe, HttpError):
        # Something went wrong server-side
        print ioe.status_code
        print ioe.headers["debug_id"]
    else:
        # Something went wrong client side
        print ioe
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
## Samples

You can start off by trying out [creating and capturing an order](/sample/CaptureIntentExamples/run_all.py)

To try out different samples for both create and authorize intent check [this link](/sample)
