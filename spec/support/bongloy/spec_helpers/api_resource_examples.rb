module Bongloy
  module SpecHelpers
    module ApiResourceExamples

      private

      shared_examples_for "a non updatable api resource" do
        it "should raise a Bongloy::Error::Api::InvalidRequestError" do
          expect { subject.save! }.to raise_error(
            Bongloy::Error::Api::InvalidRequestError, "#{described_class.name} cannot be updated"
          )
        end
      end
    end
  end
end
