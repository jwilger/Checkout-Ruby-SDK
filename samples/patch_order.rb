require_relative './sample_skeleton'
require_relative './capture_intent_examples/create_order'
require 'json'
require 'ostruct'

include CheckoutSdk::Orders

module Samples
  class PatchOrder
    def get_order(order_id)
      request = OrdersGetRequest::new(order_id)
      response = SampleSkeleton::exec(request)
      puts "Status Code: #{response.status_code}"
      puts "Status: #{response.result.status}"
      puts "Order ID: #{response.result.id}"
      puts "Intent: #{response.result.intent}"
      puts "Links:"
      for link in response.result.links
        # this could also be called as link.rel or link.href but as method is a reserved keyword for ruby avoid calling link.method
        puts "\t#{link["rel"]}: #{link["href"]}\tCall Type: #{link["method"]}"
      end
      puts "Gross Amount: #{response.result.purchase_units[0].amount.currency_code} #{response.result.purchase_units[0].amount.value}"
    end
  end
end

if __FILE__ == $0
  Samples::GetOrder::new::get_order(Samples::CaptureIntentExamples::CreateOrder::new::create_order)
end