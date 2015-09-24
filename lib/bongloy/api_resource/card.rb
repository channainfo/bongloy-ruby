module Bongloy
  module ApiResource
    class Card < ::Bongloy::ApiResource::Base

      attr_accessor :customer

      def initialize(customer, params = {})
        self.customer = customer
        super(params)
      end

      def source=(value)
        params[:source] = value
      end

      private

      def resources_path
        "customers/#{customer.id}/payment_sources"
      end
    end
  end
end
