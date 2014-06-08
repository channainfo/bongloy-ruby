require_relative "base"

module Bongloy
  module Error
    module Api
      class InvalidRequestError < Base

        def message
          @message || "Bad Request."
        end
      end
    end
  end
end
