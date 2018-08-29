require_relative '../test_harness'

include CheckoutSdk::Orders

module OrdersHelper
  class << self
    def create_order
      body = {
          intent: 'CAPTURE',
          purchase_units: [{
                               reference_id: 'test_ref_id1',
                               amount: {
                                   value: '100.00',
                                   currency_code: 'USD'
                               }
                           }],
          redirect_urls: {
              cancel_url: 'https://example.com/cancel',
              return_url: 'https://example.com/return'
          }
      }
      request = OrdersCreateRequest.new()
      request.prefer("return=representation")
      request.request_body(body)

      return TestHarness::client.execute(request)
    end

    def get_order(id)
      return TestHarness::exec(OrdersGetRequest.new(id))
    end
  end
end
