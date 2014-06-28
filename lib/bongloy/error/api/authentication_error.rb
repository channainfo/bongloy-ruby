require_relative "base"

module Bongloy
  module Error
    module Api
      class AuthenticationError < ::Bongloy::Error::Api::Base

        def message
          @message || "No valid API key provided."
        end
      end
    end
  end
end
