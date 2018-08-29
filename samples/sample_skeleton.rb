require_relative '../lib/lib'

module SampleSkeleton
  class << self

    def openstruct_to_hash(object, hash = {})
      object.each_pair do |key, value|
        hash[key] = value.is_a?(OpenStruct) ? openstruct_to_hash(value) : value
      end
      hash
    end

    def environment
      client_id = ENV['PAYPAL_CLIENT_ID'] || 'AVNCVvV9oQ7qee5O8OW4LSngEeU1dI7lJAGCk91E_bjrXF2LXB2TK2ICXQuGtpcYSqs4mz1BMNQWuso1'
      client_secret = ENV['PAYPAL_CLIENT_SECRET'] || 'EDQzd81k-1z2thZw6typSPOTEjxC_QbJh6IithFQuXdRFc7BjVht5rQapPiTaFt5RC-HCa1ir6mi-H5l'

      PayPal::SandboxEnvironment.new(client_id, client_secret)
    end

    def client
      PayPal::PayPalHttpClient.new(self.environment)
    end

    def exec(req, body = nil)
      if body
        req.request_body(body)
      end

      client.execute(req)
    end
  end
end
