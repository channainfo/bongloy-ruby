require_relative "base"

module Bongloy
  module ApiResource
    class Token < Base

      private

      def resources_path
        :tokens
      end
    end
  end
end
