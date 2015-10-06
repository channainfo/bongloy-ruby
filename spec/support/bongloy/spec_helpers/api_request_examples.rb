module Bongloy
  module SpecHelpers
    module ApiRequestExamples

      private

      def expect_api_request(request_type, options = {}, &block)
        api_request_helpers.expect_api_request(
          {
            :api_resource_endpoint => api_resource_endpoint,
            :cassette_dir => cassette_dir,
            :request_type => request_type
          }.merge(options), &block
        )
      end

      def request_body
        WebMock::Util::QueryMapper.query_to_values(WebMock.requests.last.body)
      end

      shared_examples_for "a bongloy api resource" do
        let(:api_helpers) { Bongloy::SpecHelpers::ApiHelpers.new }
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
          expect(actual_headers).to include(api_helpers.asserted_bongloy_account_headers(bongloy_account))
        end

        def set_stripe_mode
          allow(ENV).to receive(:[]).and_call_original
          allow(ENV).to receive(:[]).with("STRIPE_MODE").and_return("1")
        end

        describe "#initialize(params = {})" do
          context "passing an :api_key" do
            let(:api_key) { "pk_test_12345" }
            subject { build(factory, :api_key => api_key) }
            it { expect(subject.api_key).to eq(api_key) }
          end

          context "without passing an :api_key" do
            it { expect(subject.api_key).to eq(ENV["BONGLOY_SECRET_KEY"]) }
          end
        end

        describe "#id" do
          it { expect(subject.id).to eq(nil); subject.id = 1; expect(subject.id).to eq(1) }
          it { expect(subject.id).to eq(nil); subject.params = {:id => 1}; expect(subject.id).to eq(1) }
        end

        describe "#bongloy_account" do
          it { expect(subject.bongloy_account).to eq(nil) }
          it { expect(build(factory, :bongloy_account => bongloy_account).bongloy_account).to eq(bongloy_account) }
          it { subject.bongloy_account = bongloy_account; expect(subject.headers[:bongloy_account]).to eq(bongloy_account) }
        end

        describe "#headers" do
          it { expect(subject.headers).to eq({}) }
          it { expect(build(factory, :headers => {"Foo" => "Bar"}).headers).to eq({"Foo" => "Bar"}) }
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
          let(:request_options) { {} }

          def setup_scenario
          end

          before do
            setup_scenario
          end

          context "with an invalid key" do
            def assert_unauthorized_request!
              expect_api_request(:unauthorized, request_options) do
                expect { subject.save! }.to raise_error(Bongloy::Error::Api::AuthenticationError)
              end
            end

            it { assert_unauthorized_request! }
          end

          context "passing request headers" do
            def setup_scenario
              setup_header_example
            end

            before do
              expect_api_request(:created) { subject.save!(request_headers) }
            end

            it { assert_headers! }
          end

          context "for a new resource" do
            context "with invalid params" do
              subject { build(factory, :invalid) }

              def assert_invalid_request!
                expect_api_request(:invalid_request, request_options) do
                  expect { subject.save! }.to raise_error(Bongloy::Error::Api::InvalidRequestError)
                end
              end

              it { assert_invalid_request! }

              context "in stripe mode" do
                let(:request_options) { { :stripe_mode => true } }

                def setup_scenario
                  set_stripe_mode
                end

                it { assert_invalid_request! }
              end
            end

            context "with valid params" do
              let(:result) { expect_api_request(:created, request_options) { subject.save! } }

              def assert_created!
                expect(result).to eq(true)
                expect(subject.id).not_to eq(nil)
              end

              def setup_scenario
                result
              end

              it { assert_created! }

              context "passing optional params" do
                subject { build(factory, :with_optional_params) }
                let(:asserted_params) { subject.params }

                def setup_scenario
                  asserted_params
                  super
                end

                it { expect(request_body).to eq(asserted_params) }
              end
            end
          end
        end

        describe "#retrieve!(query_params = {}, request_headers = {})" do
          context "without first specifying an id" do
            let(:subject) { build(factory) }
            it { expect { subject.retrieve! }.to raise_error(Bongloy::Error::Api::NotFoundError) }
          end

          context "specifying an id" do
            let(:subject) { build(factory, :with_id, :id => "replace_me_with_valid_id") }
            let(:request_options) { {} }
            let(:query_params) { {} }

            def setup_scenario
            end

            before do
              setup_scenario
              expect_api_request(:ok, {:api_resource_id => subject.id}.merge(request_options)) do
                subject.retrieve!(query_params, request_headers)
              end
            end

            it { expect(subject.object).to eq(asserted_retrieved_object) }

            context "passing additional params" do
              let(:request_options) { { :match_requests_on => [:method, :host, :path] } }
              let(:query_params) { additional_params }

              it { assert_additional_params! }
            end

            context "passing request headers" do
              def setup_scenario
                setup_header_example
              end

              it { assert_headers! }
            end
          end
        end
      end
    end
  end
end
