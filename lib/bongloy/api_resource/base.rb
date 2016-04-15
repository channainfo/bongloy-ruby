require_relative "../client"

module Bongloy
  module ApiResource
    class Base
      attr_accessor :api_key, :id, :params, :headers

      class Attributes < Hash
        include Hashie::Extensions::MethodAccess
        include Hashie::Extensions::IndifferentAccess
      end

      def initialize(options = {})
        self.params = options.dup
        self.headers = params.delete(:headers) || {}
        self.bongloy_account = params.delete(:bongloy_account)
        self.id = params.delete(:id)
        self.api_key = params.delete(:api_key) || client.api_key
      end

      def save!(request_headers = {})
        headers = build_request_headers(request_headers)

        if persisted?
          raise(::Bongloy::Error::Api::InvalidRequestError.new(
            :message => "#{self.class.name} cannot be updated"
          )) unless updatable?
          client.update_resource(resource_path, api_key, params, headers)
        else
          self.params = client.create_resource(resources_path, api_key, params, headers)
        end
        true
      end

      def retrieve!(query_params = {}, request_headers = {})
        raise(::Bongloy::Error::Api::NotFoundError.new(
          :message => "No 'id' specified. You must specify an 'id' for this resource like this: #{self.class.name}.new(:id => <id>)"
        )) unless persisted?
        self.params = client.show_resource(
          resource_path, api_key, query_params, build_request_headers(request_headers)
        )
      end

      def params=(options)
        @params = Attributes[options]
      end

      def params(options = {})
        options[:root] && @params[:object] ? {@params[:object] => @params} : @params
      end

      def id
        @id || params[:id]
      end

      def client
        @client ||= ::Bongloy::Client.new
      end

      def bongloy_account
        headers["Bongloy-Account"]
      end

      def bongloy_account=(value)
        self.headers["Bongloy-Account"] = value if value
      end

      def headers=(value)
        @headers = value.dup
      end

      private

      def build_request_headers(request_headers = {})
        request_headers.merge(self.headers)
      end

      def resource_path
        "#{resources_path}/#{id}"
      end

      def updatable?
        true
      end

      def persisted?
        !id.nil?
      end

      def method_missing(name, *args)
        params.public_send(name)
      end
    end
  end
end
