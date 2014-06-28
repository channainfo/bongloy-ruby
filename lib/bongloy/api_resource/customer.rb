module Bongloy
  module ApiResource
    class Customer < ::Bongloy::ApiResource::Base
      def card=(token)
        params[:card] = token
      end

      def email=(email)
        params[:email] = email
      end

      def description=(description)
        params[:description] = description
      end

      private

      def resources_path
        :customers
      end
    end
  end
end
