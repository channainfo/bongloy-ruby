require_relative "base"

module Bongloy
  module Error
    module Api
      class NotFoundError < Base
        attr_accessor :resource

        def initialize(options = {})
          super
          self.resource = options[:resource]
        end

        def message
          @message || "No such resource: #{resource}"
        end
      end
    end
  end
end
