require_relative '../sample_skeleton'
include CheckoutSdk::Orders
module Samples
  module CaptureIntentExamples
    class CaptureOrder
      def capture_order (order_id, debug=false)
        request = OrdersCaptureRequest::new(order_id)
        request.prefer("return=representation")
        begin
          response = SampleSkeleton::exec(request)
        rescue => e
          puts e.result
        end
        if debug
          puts "Status Code: #{response.status_code}"
          puts "Status: #{response.result.status}"
          puts "Order ID: #{response.result.id}"
          puts "Intent: #{response.result.intent}"
          puts "Links:"
          for link in response.result.links
            # this could also be called as link.rel or link.href but as method is a reserved keyword for ruby avoid calling link.method
            puts "\t#{link["rel"]}: #{link["href"]}\tCall Type: #{link["method"]}"
          end
          puts "Buyer:"
          buyer = response.result.payer
          puts "\tEmail Address: #{buyer.email_address}\n\tName: #{buyer.name.full_name}\n\tPhone Number: #{buyer.phone.phone_number.national_number}"
          end
        return response
      end
    end
  end
end

if __FILE__ == $0
  Samples::CaptureIntentExamples::CaptureOrder::new::capture_order('4C5113878W7268015', true)
end