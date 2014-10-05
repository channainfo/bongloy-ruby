require_relative "base_error"

module Bongloy
  module Error
    module Api
      class InvalidRequestError < ::Bongloy::Error::Api::BaseError

        private

        def default_message_string
          "Request could not be processed."
        end
      end
    end
  end
end
