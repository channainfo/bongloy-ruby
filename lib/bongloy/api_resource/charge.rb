module Bongloy
  module ApiResource
    class Charge < ::Bongloy::ApiResource::Base
      def card=(token)
        params[:card] = token
      end

      private

      def resources_path
        :charges
      end
    end
  end
end
