require_relative "base"

module Bongloy
  module ApiResource
    class Token < ::Bongloy::ApiResource::Base
      def card=(card)
        params[:card] = card
      end

      def customer=(customer)
        params[:customer] = customer
      end

      private

      def updatable?
        false
      end

      def resources_path
        :tokens
      end
    end
  end
end
