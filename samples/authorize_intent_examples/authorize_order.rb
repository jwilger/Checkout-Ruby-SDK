require_relative '../sample_skeleton'
include CheckoutSdk::Orders
module Samples
  module AuthorizeIntentExamples
    class AuthorizeOrder
      def authorize_order (order_id, debug=false)
        request = OrdersAuthorizeRequest::new(order_id)
        request.prefer("return=representation")
        request.request_body({})
        response = SampleSkeleton::exec(request)
        if debug
          puts "Status Code: #{response.status_code}"
          puts "Status: #{response.result.status}"
          puts "Order ID: #{response.result.id}"
          puts "Authorization ID: #{response.result.purchase_units[0].payments.authorizations[0].id}"
          puts "Intent: #{response.result.intent}"
          puts "Links:"
          for link in response.result.links
            # this could also be called as link.rel or link.href but as method is a reserved keyword for ruby avoid calling link.method
            puts "\t#{link["rel"]}: #{link["href"]}\tCall Type: #{link["method"]}"
          end
          puts "Authorization Links:"
          for link in response.result.purchase_units[0].payments.authorizations[0].links
            # this could also be called as link.rel or link.href but as method is a reserved keyword for ruby avoid calling link.method
            puts "\t#{link["rel"]}: #{link["href"]}\tCall Type: #{link["method"]}"
          end
          puts "Buyer:"
          buyer = response.result.payer
          puts "\tEmail Address: #{buyer.email_address}\n\tName: #{buyer.name.given_name} #{buyer.name.surname}\n\tPhone Number: #{buyer.phone.phone_number.national_number}"
        end
        return response
      end
    end
  end
end

if __FILE__ == $0
  Samples::AuthorizeIntentExamples::AuthorizeOrder::new::authorize_order('8BL07497S03105947')
end