require_relative "base"

module Bongloy
  module ApiResource
    module ApiKey
      class Publishable < Base
        attr_accessor :value

        def initialize(value)
          self.value = value
        end

        def valid?
          begin
            Bongloy::ApiResource::Token.new(:key => value).save!
          rescue Bongloy::InvalidRequestError
            true
          rescue Bongloy::AuthenticationError
            false
          end
        end
      end
    end
  end
end
