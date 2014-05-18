require 'spec_helper'

module Bongloy
  module ApiResource
    describe Token do
      include Bongloy::SpecHelpers::ApiResourceExamples

      let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
      let(:api_resource_endpoint) { :tokens }

      subject { build(:token) }

      it_should_behave_like "a bongloy api resource"

      describe "#save!" do
        it "should save the resource" do
          expect_api_request(:created) { subject.save! }
        end

        context "with invalid params" do
          subject { build(:token, :invalid) }

          it "should raise a Bongloy::Error::Api::InvalidRequestError" do
            expect_api_request(:invalid_request) do
              expect { subject.save! }.to raise_error(Bongloy::Error::Api::InvalidRequestError)
            end
          end
        end
      end
    end
  end
end
