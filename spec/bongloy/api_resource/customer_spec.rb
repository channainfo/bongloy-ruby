require 'spec_helper'

describe Bongloy::ApiResource::Customer do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { :customers }
  let(:asserted_retrieved_object) { "customer" }
  let(:cassette_dir) { api_resource_endpoint }
  let(:factory) { :customer }
  subject { build(factory) }

  it_should_behave_like "a bongloy api resource"

  describe "#source=(token)" do
    before { subject.source = "token" }
    it { expect(subject.params[:source]).to eq("token") }
  end

  describe "#save!(request_headers = {})" do
    let(:request_options) { {} }

    before do
      expect_api_request(playback_type, request_options) do
        subject.save!
      end
    end

    context "for a new customer" do
      context "when the customer has no source" do
        let(:playback_type) { :created }
        it { expect(subject.default_source).to eq(nil) }
      end

      context "when the customer has a valid source" do
        subject { build(:customer, :with_source, :source => "replace_me_with_a_valid_token") }
        let(:playback_type) { :created_with_source }
        it { expect(subject.default_source).not_to eq(nil) }
      end
    end

    context "for an existing customer" do
      subject { build(:customer, :with_id, :with_source, :with_optional_params, :id => "replace_me_with_valid_customer_id", :source => "replace_me_with_a_valid_token") }
      let(:request_options) { { :api_resource_id => subject.id } }
      let(:playback_type) { :updated }

      it "should update the remote customer" do
        expect(request_body["source"]).to eq(subject.source)
        expect(request_body["email"]).to eq(subject.email)
        expect(request_body["description"]).to eq(subject.description)
      end
    end
  end
end
