require_relative '../sample_skeleton'
require_relative '../capture_intent_examples/create_order'
require_relative '../capture_intent_examples/capture_order'
include BraintreeHttp
puts "Creating Order..."
create_resp = Samples::CaptureIntentExamples::CreateOrder::new::create_order
for link in create_resp.result.links
  # this could also be called as link.rel or link.href but as method is a reserved keyword for ruby avoid calling link.method
  puts "\t#{link["rel"]}: #{link["href"]}\tCall Type: #{link["method"]}"
end
puts "Created Successfully\n"
puts "Copy approve link and paste it in browser. Login with buyer account and follow the instructions.\nOnce approved hit enter..."

# Waiting for user input
gets

puts "Capturing Order..."
begin
  capture_resp = Samples::CaptureIntentExamples::CaptureOrder::new::capture_order(create_resp.result.id)
rescue => e
  if e.is_a? HttpError
    puts e.message
    puts e.status_code
    puts e.result
  end
end

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
