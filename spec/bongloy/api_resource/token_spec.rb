require 'spec_helper'

describe Bongloy::ApiResource::Token do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { :tokens }
  let(:asserted_retrieved_object) { "token" }
  let(:cassette_dir) { api_resource_endpoint }
  let(:factory) { :token }
  subject { build(factory) }

  it_should_behave_like "a bongloy api resource"

  describe "#card=(card)" do
    let(:card_params) { {"number" => "4242424242424242", "exp_month" => 12, "exp_year" => 2015} }
    before { subject.card = card_params }
    it { expect(subject.params[:card]).to eq(card_params) }
  end

  describe "#save!(request_headers = {})" do
    context "for an existing token" do
      subject { build(:token, :with_id) }
      it_should_behave_like "a non updatable api resource"
    end

    context "for a new token" do
      context "with a card" do
        subject { build(:token) }
        before { expect_api_request(:created) { subject.save! } }
        it { expect(request_body).to have_key("card") }
      end
    end
  end
end
