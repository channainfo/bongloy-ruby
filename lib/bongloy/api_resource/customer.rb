module Bongloy
  module ApiResource
    class Customer < Base

      private

      def resources_path
        :customers
      end
    end
  end
end
