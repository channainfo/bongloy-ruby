require_relative "base"

module Bongloy
  module Error
    module Api
      class InvalidRequestError < ::Bongloy::Error::Api::Base

        def message
          @message || "Bad Request."
        end
      end
    end
  end
end
