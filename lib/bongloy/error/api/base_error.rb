module Bongloy
  module Error
    module Api
      class BaseError < ::StandardError
        attr_accessor :code, :errors, :message

        def initialize(options = {})
          self.code = options[:code]
          self.errors = options[:errors]
          self.message = options[:message]
        end

        def message
          default_message_with_code
        end

        def to_json
          to_hash.to_json
        end

        def to_hash
          JSON.parse((errors || default_errors)).merge("code" => code)
        end

        private

        def full_error_messages(attribute, messages)
          return messages if attribute == "base"
          messages.map { |message| "#{attribute} #{message}" }
        end

        def default_message
          parsed_errors = errors && JSON.parse(errors)["error"]
          parsed_errors ? parsed_errors.map { |attribute, messages| full_error_messages(attribute, messages)}.join(", ") : message_string
        end

        def default_message_with_code
          [code, default_message].compact.join(". ")
        end

        def message_string
          @message || default_message_string
        end

        def default_message_string
          "An API error has occured. We have been notified and are looking into it."
        end

        def default_errors
          {"errors" => {"base" => [message_string]}}.to_json
        end
      end
    end
  end
end
