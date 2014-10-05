require_relative "base_error"

module Bongloy
  module Error
    module Api
      class NotFoundError < ::Bongloy::Error::Api::BaseError
        attr_accessor :resource

        def initialize(options = {})
          super
          self.resource = options[:resource]
        end

        def to_hash
          resource ? super.merge("resource" => resource) : super
        end

        private

        def default_message_string
          ["No such resource", resource].compact.join(": ")
        end
      end
    end
  end
end
