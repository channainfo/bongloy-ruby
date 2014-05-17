module Bongloy
  class Client
    require 'httparty'

    BONGLOY_API_ENDPOINT = "https://api.bongloy.com/v1"

    def create_resource(path, api_key, params = {}, headers = {})
      handle_response(
        HTTParty.post(
          resource_endpoint(path),
          :body => params,
          :headers => authentication_headers(api_key).merge(headers)
        )
      )
    end

    private

    def handle_response(response)
      unless response.success?
        if response.code == 401
          raise(::Bongloy::Error::Api::AuthenticationError)
        elsif response.code == 422 || response.code == 400
          raise(::Bongloy::Error::Api::InvalidRequestError)
        else
          raise(::Bongloy::Error::Api::Base)
        end
      end
      JSON.parse(response.body)
    end

    def authentication_headers(api_key)
      {"Authorization" => "Bearer #{api_key}"}
    end

    def resource_endpoint(path)
      "#{api_endpoint}/#{path}"
    end

    def api_endpoint
      ENV["BONGLOY_API_ENDPOINT"] || BONGLOY_API_ENDPOINT
    end
  end
end
