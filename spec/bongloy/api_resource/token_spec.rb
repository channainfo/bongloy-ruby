require 'spec_helper'

module Bongloy
  module ApiResource
    describe Token do
      include Bongloy::SpecHelpers::ApiRequestExamples

      let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
      let(:api_resource_endpoint) { :tokens }

      subject { build(:token) }

      it_should_behave_like "a bongloy api resource"

      describe "#save!" do
        it "should save the resource" do
          # the account which the token belongs to must be the BONGLOY_SECRET_KEY
          expect_api_request(:created) do
            subject.save!
            subject.card.should_not be_nil
          end
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

      describe "#retrieve!" do
        context "without first specifying an id" do
          it "should raise a Bongloy::Error::Api::NotFoundError" do
            expect { subject.retrieve! }.to raise_error(Bongloy::Error::Api::NotFoundError)
          end
        end

        context "specifying an id" do
          # the account which the token belongs to must be the BONGLOY_SECRET_KEY
          subject { build(:token, :with_id, :id => "tok_replace_me_with_an_actual_token") }

          it "should try to find the resource by the given id" do
            expect_api_request(:ok, :api_resource_id => subject.id) do
              subject.retrieve!
              subject.card.should_not be_nil
            end
          end
        end
      end
    end
  end
end
