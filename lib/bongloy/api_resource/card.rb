module Bongloy
  module ApiResource
    class Card < ::Bongloy::ApiResource::Base

      attr_accessor :customer

      def initialize(customer_id, params = {})
        self.customer = customer_id
        super(params)
      end

      def source=(value)
        params[:source] = value
      end

      def name=(value)
        params[:name] = value
      end

      def exp_month=(value)
        params[:exp_month] = value
      end

      def exp_year=(value)
        params[:exp_year] = value
      end

      def address_line1=(value)
        params[:address_line1] = value
      end

      def address_line2=(value)
        params[:address_line2] = value
      end

      def address_city=(value)
        params[:address_city] = value
      end

      def address_state=(value)
        params[:address_state] = value
      end

      def address_zip=(value)
        params[:address_zip] = value
      end

      def address_country=(value)
        params[:address_country] = value
      end

      private

      def resources_path
        "customers/#{customer}/payment_sources"
      end
    end
  end
end
