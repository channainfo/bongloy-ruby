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

      def request_body
        WebMock::Util::QueryMapper.query_to_values(WebMock.requests.last.body)
      end

      shared_examples_for "a bongloy api resource" do
        let(:additional_params) { { "expand" => ["default_source"] } }
        let(:request_headers) { { "X-Foo" => "bar" } }
        let(:resource_headers) { { "X-Resource-Header" => "baz" } }
        let(:bongloy_account) { "acct_1234" }

        def assert_additional_params!
          expect(WebMock::Util::QueryMapper.query_to_values(WebMock.requests.last.uri.query)).to eq(additional_params)
        end

        def setup_header_example
          subject.headers = resource_headers
          subject.bongloy_account = bongloy_account
        end

        def assert_headers!
          actual_headers = WebMock.requests.last.headers
          expect(actual_headers).to include(request_headers)
          expect(actual_headers).to include(resource_headers)
          expect(actual_headers).to include({"Bongloy-Account" => bongloy_account})
        end

        describe "#initialize(options = {})" do
          context "passing an :api_key" do
            let(:api_key) { "pk_test_12345" }
            subject { described_class.new(:api_key => api_key) }
            it { expect(subject.api_key).to eq(api_key) }
          end

          context "without passing an :api_key" do
            it { expect(subject.api_key).to eq(ENV["BONGLOY_SECRET_KEY"]) }
          end
        end

        describe "#id" do
          it "should behave like a normal getter/setter" do
            expect(subject.id).to be_nil
            subject.id = 1
            expect(subject.id).to eq(1)
          end

          it "should look in the params hash for the id" do
            expect(subject.id).to be_nil
            subject.params = {:id => 1}
            expect(subject.id).to eq(1)
          end
        end

        describe "#bongloy_account" do
          it { expect(subject.bongloy_account).to eq(nil) }
          it { expect(described_class.new(:bongloy_account => bongloy_account).bongloy_account).to eq(bongloy_account) }
          it { subject.bongloy_account = bongloy_account; expect(subject.headers[:bongloy_account]).to eq(bongloy_account) }
        end

        describe "#headers" do
          it { expect(subject.headers).to eq({}) }
          it { expect(described_class.new(:headers => {"Foo" => "Bar"}).headers).to eq({"Foo" => "Bar"}) }
        end

        describe "#params(options = {})" do
          let(:sample_params) { {"foo" => "bar"} }
          let(:options) { {} }
          let(:result) { subject.params(options) }

          before { subject.params = sample_params }

          it { expect(result).to eq(sample_params) }
          it { expect(subject.foo).to eq("bar") }

          context "passing(:root => true)" do
            let(:options) { {:root => true} }

            context "does not include a 'object' key" do
              it { expect(result).to eq(sample_params) }
            end

            context "includes a 'object' key" do
              let(:sample_params) { { "object" => "token" } }
              it { expect(result).to eq(sample_params["object"] => sample_params) }
            end
          end

          it "should have indifferent access" do
            expect(result["foo"]).to eq(sample_params["foo"])
            expect(result[:foo]).to eq(sample_params["foo"])
          end
        end

        describe "#client" do
          it { expect(subject.client).to be_a(Bongloy::Client) }
        end

        describe "#save!(request_headers = {})" do
          context "with an invalid key" do
            it "should raise a Bongloy::Error::Api::AuthentiationError" do
              expect_api_request(:unauthorized) do
                expect { subject.save! }.to raise_error(Bongloy::Error::Api::AuthenticationError)
              end
            end
          end

          context "passing request headers" do
            before { setup_header_example }

            it "should send these headers in the request" do
              expect_api_request(:created) do
                subject.save!(request_headers)
              end
              assert_headers!
            end
          end

          context "for a new resource" do
            context "with invalid params" do
              subject { build(factory, :invalid) }

              it "should raise a Bongloy::Error::Api::InvalidRequestError" do
                expect_api_request(:invalid_request) do
                  expect { subject.save! }.to raise_error(Bongloy::Error::Api::InvalidRequestError)
                end
              end

              context "in stripe mode" do
                before do
                  allow(ENV).to receive(:[]).and_call_original
                  allow(ENV).to receive(:[]).with("STRIPE_MODE").and_return("1")
                end

                it "should rails a Bongloy::Error::Api::InvalidRequestError" do
                  expect_api_request(:invalid_request, :stripe_mode => true) do
                    expect { subject.save! }.to raise_error(Bongloy::Error::Api::InvalidRequestError)
                  end
                end
              end
            end

            context "with valid params" do
              it "should return true" do
                expect_api_request(:created) do
                  expect(subject.save!).to eq(true)
                  expect(subject.id).not_to be_nil
                end
              end

              context "passing optional params" do
                subject { build(factory, :with_optional_params) }
                let(:asserted_params) { subject.params }

                before do
                  asserted_params
                  expect_api_request(:created) do
                    subject.save!
                  end
                end

                it { expect(request_body).to eq(asserted_params) }
              end
            end
          end
        end

        describe "#retrieve!(query_params = {}, request_headers = {})" do
          context "without first specifying an id" do
            let(:subject) { described_class.new }
            it { expect { subject.retrieve! }.to raise_error(Bongloy::Error::Api::NotFoundError) }
          end

          context "specifying an id" do
            let(:subject) { described_class.new(:id => "replace_me_with_actual_resource_uuid") }

            it "should try to find the resource by the given id" do
              expect_api_request(:ok, :api_resource_id => subject.id) do
                subject.retrieve!
                expect(subject.object).to eq(asserted_retrieved_object)
              end
            end

            context "passing additional params" do
              it "should send these params in the query string" do
                expect_api_request(:ok, :api_resource_id => subject.id, :match_requests_on => [:method, :host, :path]) do
                  subject.retrieve!(additional_params)
                end
                assert_additional_params!
              end
            end

            context "passing request headers" do
              before { setup_header_example }

              it "should send these headers in the request" do
                expect_api_request(:ok, :api_resource_id => subject.id) do
                  subject.retrieve!({}, request_headers)
                end
                assert_headers!
              end
            end
          end
        end
      end
    end
  end
end
