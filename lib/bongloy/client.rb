module Bongloy
  class Client
    require 'httparty'

    BONGLOY_API_ENDPOINT = "https://bongloy-staging.herokuapp.com/api/v1"
    STRIPE_API_ENDPOINT = "https://api.stripe.com/v1"

    attr_accessor :api_endpoint

    def initialize(options = {})
      self.api_endpoint = options[:api_endpoint] || (ENV["STRIPE_MODE"].to_i == 1 ? (ENV["STRIPE_API_ENDPOINT"] || STRIPE_API_ENDPOINT) : (ENV["BONGLOY_API_ENDPOINT"] || BONGLOY_API_ENDPOINT))
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

    def api_key
      stripe_mode? ? ENV["STRIPE_SECRET_KEY"] : ENV["BONGLOY_SECRET_KEY"]
    end

    def stripe_mode?
      api_endpoint == ENV["STRIPE_API_ENDPOINT"]
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
          raise(::Bongloy::Error::Api::AuthenticationError.new(:code => response.code))
        elsif response.code == 400 || response.code == 422
          raise(::Bongloy::Error::Api::InvalidRequestError.new(:code => response.code, :errors => response.body))
        elsif response.code == 404
          raise(::Bongloy::Error::Api::NotFoundError.new(:code => response.code, :resource => response.request.path.to_s))
        else
          raise(::Bongloy::Error::Api::BaseError.new(:code => response.code))
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
