require 'spec_helper'

describe Bongloy::ApiResource::Charge do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { :charges }
  let(:asserted_retrieved_object) { "charge" }
  let(:cassette_dir) { api_resource_endpoint }
  let(:factory) { :charge }
  subject { build(factory, :source => "replace_me_with_valid_token") }

  it_should_behave_like "a bongloy api resource"

  describe "#source=(source_id)" do
    before { subject.source = "tok_my_token" }
    it { expect(subject.params[:source]).to eq("tok_my_token") }
  end

  describe "#customer=(customer_id)" do
    before { subject.customer = "cus_my_customer_id" }
    it { expect(subject.params[:customer]).to eq("cus_my_customer_id") }
  end

  describe "#capture=(value)" do
    before { subject.capture = false }
    it { expect(subject.params[:capture]).to eq(false) }
  end

  describe "#description=(value)" do
    before { subject.description = "some description" }
    it { expect(subject.params[:description]).to eq("some description") }
  end

  describe "#amount=(value)" do
    before { subject.amount = 1000 }
    it { expect(subject.params[:amount]).to eq(1000) }
  end

  describe "#currency=(value)" do
    before { subject.currency = "khr" }
    it { expect(subject.params[:currency]).to eq("khr") }
  end

  describe "#save!(request_headers = {})" do
    context "for an existing charge" do
      subject { build(factory, :with_id) }
      it_should_behave_like "a non updatable api resource"
    end
  end
end
