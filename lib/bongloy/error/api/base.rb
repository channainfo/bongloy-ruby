module Bongloy
  module Error
    module Api
      class Base < ::StandardError
        def message
          "An API error has occured. We have been notified and are looking into it."
        end
      end
    end
  end
end
