module Bongloy
  module SpecHelpers
    class ApiRequestHelpers
      def expect_api_request(options = {}, &block)
        request_options = options.dup

        stripe_mode = request_options.delete(:stripe_mode)
        if stripe_mode
          api_endpoint = ENV['STRIPE_API_ENDPOINT']
          cassette_dir = "stripe/api_resources"
        else
          api_endpoint = ENV['BONGLOY_API_ENDPOINT']
          cassette_dir = "api_resources"
        end

        api_resource_endpoint = request_options.delete(:api_resource_endpoint)
        api_resource_id = request_options.delete(:api_resource_id)
        cassette_sub_dir = request_options.delete(:cassette_dir)
        cassette_suffix = :slash_id if api_resource_id
        request_type = request_options.delete(:request_type)

        cassette = request_options.delete(:cassette) || [
          cassette_dir, [cassette_sub_dir || api_resource_endpoint, cassette_suffix].compact.join("_"), request_type.to_s
        ].compact.join("/")

        cassette_options = {
          :erb => {
            :endpoint => [
              api_endpoint, api_resource_endpoint, api_resource_id
            ].compact.join("/")
          }
        }.merge(request_options)

        VCR.use_cassette(cassette, cassette_options) { yield }
      end
    end
  end
end
