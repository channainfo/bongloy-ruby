module Bongloy
  module SpecHelpers
    module ApiRequestExamples

      private

      def expect_api_request(request_type, options = {}, &block)
        api_request_helpers.expect_api_request(
          {
            :api_resource_endpoint => api_resource_endpoint, :request_type => request_type
          }.merge(options), &block
        )
      end

      shared_examples_for "a bongloy api resource" do
        let(:custom_headers) { { "X-Foo" => "bar" } }

        def assert_custom_headers!
          WebMock.requests.last.headers.should include(custom_headers)
        end

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

        describe "#id" do
          it "should behave like a normal getter/setter" do
            subject.id.should be_nil
            subject.id = 1
            subject.id.should == 1
          end

          it "should look in the params hash for the id" do
            subject.id.should be_nil
            subject.params = {:id => 1}
            subject.id.should == 1
          end
        end

        describe "#params" do
          let(:sample_params) {  }

          before do
            subject.params = {"foo" => "bar"}
          end

          it "should behave like a normal getter/setter" do
            subject.params.should == {"foo" => "bar"}
          end

          it "should set up method readers and writers for the params" do
            subject.foo.should == "bar"
          end

          it "should have indifferent access" do
            subject.params["foo"].should == "bar"
            subject.params[:foo].should == "bar"
          end
        end

        describe "#save!(headers = {})" do
          context "with an invalid key" do
            it "should raise a Bongloy::Error::Api::AuthentiationError" do
              expect_api_request(:unauthorized) do
                expect { subject.save! }.to raise_error(Bongloy::Error::Api::AuthenticationError)
              end
            end
          end

          context "passing custom headers" do
            it "should send these headers in the request" do
              expect_api_request(:created) do
                subject.save!(custom_headers)
              end
              assert_custom_headers!
            end
          end

          context "for a new resource" do
            context "with valid params" do
              it "should return true" do
                expect_api_request(:created) do
                  subject.save!.should == true
                  subject.id.should_not be_nil
                end
              end
            end
          end
        end

        describe "#retrieve!(headers = {})" do
          context "without first specifying an id" do
            it "should raise a Bongloy::Error::Api::NotFoundError" do
              expect { subject.retrieve! }.to raise_error(Bongloy::Error::Api::NotFoundError)
            end
          end

          context "passing custom headers" do
            before do
              subject.id = "1234"
            end

            it "should send these headers in the request" do
              expect_api_request(:ok, :api_resource_id => subject.id) do
                subject.retrieve!(custom_headers)
              end
              assert_custom_headers!
            end
          end
        end
      end
    end
  end
end
