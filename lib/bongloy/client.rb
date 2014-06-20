module Bongloy
  class Client
    require 'httparty'

    BONGLOY_API_ENDPOINT = "https://api.bongloy.com/v1"

    attr_accessor :api_endpoint

    def initialize(options = {})
      self.api_endpoint = options[:api_endpoint] || ENV["BONGLOY_API_ENDPOINT"] || BONGLOY_API_ENDPOINT
    end

    def create_resource(path, api_key, params = {}, headers = {})
      do_request(:post, :body, path, api_key, params, headers)
    end

    def show_resource(path, api_key, params = {}, headers = {})
      do_request(:get, :query, path, api_key, params, headers)
    end

    def update_resource(path, api_key, params = {}, headers = {})
      do_request(stripe_mode? ? :post : :put, :body, path, api_key, params, headers)
    end

    def stripe_mode?
      api_endpoint =~ /api.stripe.com/
    end

    private

    def do_request(method, payload_key, path, api_key, params = {}, headers = {})
      handle_response(
        HTTParty.send(
          method,
          resource_endpoint(path),
          payload_key => params,
          :headers => authentication_headers(api_key).merge(headers)
        )
      )
    end

    def handle_response(response)
      unless response.success?
        if response.code == 401
          raise(::Bongloy::Error::Api::AuthenticationError)
        elsif response.code == 422 || response.code == 400
          raise(::Bongloy::Error::Api::InvalidRequestError.new(:message => response.body))
        elsif response.code == 404
          raise(::Bongloy::Error::Api::NotFoundError.new(:resource => response.request.path.to_s))
        else
          raise(::Bongloy::Error::Api::Base)
        end
      end
      response.body ? JSON.parse(response.body) : {}
    end

    def authentication_headers(api_key)
      {"Authorization" => "Bearer #{api_key}"}
    end

    def resource_endpoint(path)
      "#{api_endpoint}/#{path}"
    end
  end
end
