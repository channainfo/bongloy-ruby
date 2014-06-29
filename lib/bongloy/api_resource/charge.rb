module Bongloy
  module ApiResource
    class Charge < ::Bongloy::ApiResource::Base
      def card=(token)
        params[:card] = token
      end

      def amount=(value)
        params[:amount] = value
      end

      def currency=(value)
        params[:currency] = value
      end

      def capture=(value)
        params[:capture] = value
      end

      def description=(value)
        params[:description] = value
      end

      private

      def updatable?
        false
      end

      def resources_path
        :charges
      end
    end
  end
end
