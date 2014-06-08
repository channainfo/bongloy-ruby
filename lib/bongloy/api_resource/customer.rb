module Bongloy
  module ApiResource
    class Customer < Base
      def card=(token)
        params[:card] = token
      end

      private

      def resources_path
        :customers
      end
    end
  end
end
