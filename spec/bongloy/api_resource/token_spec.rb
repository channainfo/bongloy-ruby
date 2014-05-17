require 'spec_helper'

module Bongloy
  module ApiResource
    describe Token do
      it_should_behave_like "a bongloy api resource"

      describe "#save!" do
        context "with an invalid key" do
          it "should raise a Bongloy::AuthentiationError" do
            VCR.use_cassette("api_resources/token/unauthorized") do
              expect { subject.save! }.to raise_error(Bongloy::Error::Api::AuthenticationError)
            end
          end
        end

        context "with a valid key" do
          let(:api_key) { "pk_test_7d057f151650bdf8992bb1491f47270cc22d92e691b4f008082fc9721b518a0e" }

          subject { described_class.new(:api_key => api_key) }

          it "should raise a Bongloy::InvalidRequestError" do
            VCR.use_cassette("api_resources/token/invalid_request") do
              expect { subject.save! }.to raise_error(Bongloy::Error::Api::InvalidRequestError)
            end
          end
        end
      end
    end
  end
end
