module Bongloy
  module ApiResource
    class Charge < ::Bongloy::ApiResource::Base
      private

      def resources_path
        :charges
      end
    end
  end
end
