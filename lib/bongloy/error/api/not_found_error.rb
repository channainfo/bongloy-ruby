require_relative "base"

module Bongloy
  module Error
    module Api
      class NotFoundError < Base
        attr_accessor :resource, :message

        def initialize(options = {})
          self.resource = options[:resource]
          self.message = options[:message]
        end

        def message
          @message || "No such resource: #{resource}"
        end
      end
    end
  end
end
