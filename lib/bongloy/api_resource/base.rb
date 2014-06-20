require_relative "../client"

module Bongloy
  module ApiResource
    class Base
      attr_accessor :api_key, :id, :params

      class Attributes < Hash
        include Hashie::Extensions::MethodAccess
        include Hashie::Extensions::IndifferentAccess
      end

      def initialize(options = {})
        self.params = options
        self.id = params.delete(:id)
        self.api_key = params.delete(:api_key) || ENV["BONGLOY_SECRET_KEY"]
      end

      def save!(headers = {})
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

      def retrieve!(query_params = {}, headers = {})
        raise(::Bongloy::Error::Api::NotFoundError.new(
          :message => "No 'id' specified. You must specify an 'id' for this resource like this: #{self.class.name}.new(:id => <id>)"
        )) unless persisted?
        self.params = client.show_resource(resource_path, api_key, query_params, headers)
      end

      def params=(options)
        @params = Attributes[options]
      end

      def id
        @id || params[:id]
      end

      def client
        @client ||= ::Bongloy::Client.new
      end

      private

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
