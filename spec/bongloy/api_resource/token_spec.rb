require 'spec_helper'

module Bongloy
  module ApiResource
    describe Token do
      include Bongloy::SpecHelpers::ApiRequestExamples

      let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
      let(:api_resource_endpoint) { :tokens }

      subject { build(:token) }

      it_should_behave_like "a bongloy api resource"

      describe "#save!(headers = {})" do
        context "with invalid params" do
          subject { build(:token, :invalid) }

          it "should raise a Bongloy::Error::Api::InvalidRequestError" do
            expect_api_request(:invalid_request) do
              expect { subject.save! }.to raise_error(Bongloy::Error::Api::InvalidRequestError)
            end
          end
        end
      end

      describe "#retrieve!(query_params = {}, headers = {})" do
        # the account which the token belongs to must be the BONGLOY_SECRET_KEY
        subject { build(:token, :with_id, :id => "tok_replace_me_with_an_actual_token") }

        it "should try to find the resource by the given id" do
          expect_api_request(:ok, :api_resource_id => subject.id) do
            subject.retrieve!
            subject.object.should == "token"
            subject.card.should_not be_nil
          end
        end
      end
    end
  end
end
