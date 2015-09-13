module Bongloy
  module ApiResource
    class Customer < ::Bongloy::ApiResource::Base
      def source=(token)
        params[:source] = token
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
