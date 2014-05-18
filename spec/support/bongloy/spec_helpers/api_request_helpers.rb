module Bongloy
  module SpecHelpers
    class ApiRequestHelpers
      def expect_api_request(options = {}, &block)
        request_options = options.dup

        api_resource_endpoint = request_options.delete(:api_resource_endpoint)
        api_resource_id = request_options.delete(:api_resource_id)
        cassette_suffix = :slash_id if api_resource_id
        request_type = request_options.delete(:request_type)

        cassette = request_options.delete(:cassette) || [
          "api_resources", [api_resource_endpoint, cassette_suffix].compact.join("_"), request_type.to_s
        ].compact.join("/")

        cassette_options = {
          :erb => {
            :endpoint => [
              ENV['BONGLOY_API_ENDPOINT'], api_resource_endpoint, api_resource_id
            ].compact.join("/")
          }
        }.merge(request_options)

        VCR.use_cassette(cassette, cassette_options) { yield }
      end
    end
  end
end
