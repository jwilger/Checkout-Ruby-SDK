require_relative '../lib/lib'

module PayPalClient
  class << self

    # Setting up and Returns PayPal SDK environment with PayPal Access credentials.
    # For demo purpose, we are using SandboxEnvironment. In production this will be
    # LiveEnvironment.
    def environment
      client_id = ENV['PAYPAL_CLIENT_ID'] || 'AVNCVvV9oQ7qee5O8OW4LSngEeU1dI7lJAGCk91E_bjrXF2LXB2TK2ICXQuGtpcYSqs4mz1BMNQWuso1'
      client_secret = ENV['PAYPAL_CLIENT_SECRET'] || 'EDQzd81k-1z2thZw6typSPOTEjxC_QbJh6IithFQuXdRFc7BjVht5rQapPiTaFt5RC-HCa1ir6mi-H5l'
      
      PayPal::SandboxEnvironment.new(client_id, client_secret)
    end

    # Returns PayPal HTTP client instance with environment which has access
    # credentials context. This can be used invoke PayPal API's provided the
    # credentials have the access to do so.
    def client
      PayPal::PayPalHttpClient.new(self.environment)
    end

    # Utility to convert Openstruct Object to JSON hash.
    def openstruct_to_hash(object, hash = {})
      object.each_pair do |key, value|
        hash[key] = value.is_a?(OpenStruct) ? openstruct_to_hash(value) : value.is_a?(Array) ? array_to_hash(value) : value
      end
      hash
    end

    # Utility to convert Array of OpenStruct into Hash.
    def array_to_hash(array, hash= [])
      array.each do |item|
        x = item.is_a?(OpenStruct) ? openstruct_to_hash(item) : item.is_a?(Array) ? array_to_hash(item) : item
        hash << x
      end
      hash
    end
  end
end
