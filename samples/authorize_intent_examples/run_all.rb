require_relative '../sample_skeleton'
require '../authorize_intent_examples/create_order'
require_relative '../authorize_intent_examples/authorize_order'
require_relative '../authorize_intent_examples/capture_order'
puts "Creating Order..."
create_resp = Samples::AuthorizeIntentExamples::CreateOrder::new::create_order
for link in create_resp.result.links
  # this could also be called as link.rel or link.href but as method is a reserved keyword for ruby avoid calling link.method
  puts "\t#{link["rel"]}: #{link["href"]}\tCall Type: #{link["method"]}"
end
puts "Created Successfully\n"
puts "Copy approve link and paste it in browser. Login with buyer account and follow the instructions.\nOnce approved hit enter..."

# Waiting for user input
gets

puts "Authorizing Order..."
authorize_resp = Samples::AuthorizeIntentExamples::AuthorizeOrder::new::authorize_order(create_resp.result.id)
authorization_id = authorize_resp.result.purchase_units[0].payments.authorizations[0].id
puts "Authorized Successfully"

puts "Capturing Order..."
capture_resp = Samples::AuthorizeIntentExamples::CaptureOrder::new::capture_order(authorization_id)
puts "Captured Successfully\n"
puts "Status Code: #{capture_resp.status_code}"
puts "Status: #{capture_resp.result.status}"
puts "Order ID: #{capture_resp.result.id}"
puts "Intent: #{capture_resp.result.intent}"
puts "Links:"
for link in capture_resp.result.links
  # this could also be called as link.rel or link.href but as method is a reserved keyword for ruby avoid calling link.method
  puts "\t#{link["rel"]}: #{link["href"]}\tCall Type: #{link["method"]}"
end
