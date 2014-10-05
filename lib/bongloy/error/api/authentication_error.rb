require_relative "base_error"

module Bongloy
  module Error
    module Api
      class AuthenticationError < ::Bongloy::Error::Api::BaseError

        private

        def default_message_string
          "No valid API key provided."
        end
      end
    end
  end
end
