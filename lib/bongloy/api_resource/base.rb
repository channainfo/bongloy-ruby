require_relative "../client"

module Bongloy
  module ApiResource
    class Base
      attr_accessor :api_key, :id, :params

      def initialize(options = {})
        self.params = options.dup
        self.api_key = params.delete(:api_key) || ENV["BONGLOY_SECRET_KEY"]
      end

      def save!
        persisted? ? client.update_resource(resource_path, api_key, params) : client.create_resource(resources_path, api_key, params)
      end

      private

      def persisted?
        !id.nil?
      end

      def client
        @client ||= ::Bongloy::Client.new
      end
    end
  end
end
