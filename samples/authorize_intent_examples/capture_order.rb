require_relative '../sample_skeleton'
include CheckoutSdk::Payments
module Samples
  module AuthorizeIntentExamples
    class CaptureOrder
      def capture_order (authorization_id, debug=false)
        request = AuthorizationsCaptureRequest::new(authorization_id)
        request.prefer("return=representation")
        request.request_body({})
        response = SampleSkeleton::exec(request)
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
        end
        return response
      end
    end
  end
end

if __FILE__ == $0
  Samples::AuthorizeIntentExamples::CaptureOrder::new::capture_order('1T900493LT829194J')
end