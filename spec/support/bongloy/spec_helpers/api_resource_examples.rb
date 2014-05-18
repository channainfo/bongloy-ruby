module Bongloy
  module SpecHelpers
    module ApiResourceExamples

      private

      def expect_api_request(request_type, options = {}, &block)
        api_request_helpers.expect_api_request(
          {
            :api_resource_endpoint => api_resource_endpoint, :request_type => request_type
          }.merge(options), &block
        )
      end

      shared_examples_for "a bongloy api resource" do
        describe "#initialize(options = {})" do
          context "passing an :api_key" do
            let(:api_key) { "pk_test_12345" }

            subject { described_class.new(:api_key => api_key) }

            it "should set the api_key" do
              subject.api_key.should == api_key
            end
          end

          context "without passing an :api_key" do
            it "should set the api_key to ENV['BONGLOY_SECRET_KEY']" do
              subject.api_key.should == ENV["BONGLOY_SECRET_KEY"]
            end
          end
        end

        describe "#save!" do
          context "with an invalid key" do
            it "should raise a Bongloy::Error::Api::AuthentiationError" do
              expect_api_request(:unauthorized) do
                expect { subject.save! }.to raise_error(Bongloy::Error::Api::AuthenticationError)
              end
            end
          end

          context "for a new resource" do
            it "should try to create a bongloy resource" do
              api_request_helpers.expect_api_request(
                :cassette => "api_resources/unauthorized", :match_requests_on => [:host]
              ) do
                expect { subject.save! }.to raise_error(Bongloy::Error::Api::AuthenticationError)
                WebMock.requests.last.method.should == :post
              end
            end
          end
        end
      end
    end
  end
end
