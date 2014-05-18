module Bongloy
  module SpecHelpers
    class ApiRequestHelpers
      def expect_api_request(options = {}, &block)
        request_options = options.dup
        api_resource_endpoint = request_options.delete(:api_resource_endpoint)
        request_type = request_options.delete(:request_type)
        cassette = request_options.delete(:cassette) || "api_resources/#{api_resource_endpoint}/#{request_type}"
        cassette_options = {
          :erb => {
            :endpoint => "#{ENV['BONGLOY_API_ENDPOINT']}/#{api_resource_endpoint}"
          }.merge(options[:erb] || {})
        }.merge(request_options)
        VCR.use_cassette(cassette, cassette_options) { yield }
      end
    end
  end
end
