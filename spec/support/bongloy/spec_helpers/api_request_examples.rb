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
        let(:additional_params) { { "expand" => ["default_card"] } }
        let(:custom_headers) { { "X-Foo" => "bar" } }

        def assert_additional_params!
          expect(WebMock::Util::QueryMapper.query_to_values(WebMock.requests.last.uri.query)).to eq(additional_params)
        end

        def assert_custom_headers!
          expect(WebMock.requests.last.headers).to include(custom_headers)
        end

        describe "#initialize(options = {})" do
          context "passing an :api_key" do
            let(:api_key) { "pk_test_12345" }

            subject { described_class.new(:api_key => api_key) }

            it "should set the api_key" do
              expect(subject.api_key).to eq(api_key)
            end
          end

          context "without passing an :api_key" do
            it "should set the api_key to ENV['BONGLOY_SECRET_KEY']" do
              expect(subject.api_key).to eq(ENV["BONGLOY_SECRET_KEY"])
            end
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
          it "should return a new client object" do
            expect(subject.client).to be_a(Bongloy::Client)
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

                it "should send the additional params in the request" do
                  expect(request_body).to eq(asserted_params)
                end
              end
            end
          end
        end

        describe "#retrieve!(query_params = {}, headers = {})" do
          context "without first specifying an id" do
            let(:subject) { described_class.new }

            it "should raise a Bongloy::Error::Api::NotFoundError" do
              expect { subject.retrieve! }.to raise_error(Bongloy::Error::Api::NotFoundError)
            end
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

            context "passing custom headers" do
              it "should send these headers in the request" do
                expect_api_request(:ok, :api_resource_id => subject.id) do
                  subject.retrieve!({}, custom_headers)
                end
                assert_custom_headers!
              end
            end
          end
        end
      end
    end
  end
end
