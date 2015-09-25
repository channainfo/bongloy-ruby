require 'spec_helper'

describe Bongloy::ApiResource::Card do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { "customers/#{subject.customer}/payment_sources" }
  let(:asserted_retrieved_object) { "card" }
  let(:cassette_dir) { :cards }
  let(:factory) { :card }

  let(:customer_id) { "replace_me_with_valid_customer_id" }
  subject { build(factory, :customer => customer_id, :source => "replace_me_with_valid_token") }

  it_should_behave_like "a bongloy api resource"

  describe "#source=(value)" do
    before { subject.source = "source_id" }
    it { expect(subject.params[:source]).to eq("source_id") }
  end

  describe "#name=(value)" do
    before { subject.name = "name" }
    it { expect(subject.params[:name]).to eq("name") }
  end

  describe "#exp_month=(value)" do
    before { subject.exp_month = "01" }
    it { expect(subject.params[:exp_month]).to eq("01") }
  end

  describe "#exp_year=(value)" do
    before { subject.exp_year = "2017" }
    it { expect(subject.params[:exp_year]).to eq("2017") }
  end

  describe "#address_line1=(value)" do
    before { subject.address_line1 = "Address Line 1" }
    it { expect(subject.params[:address_line1]).to eq("Address Line 1") }
  end

  describe "#address_line2=(value)" do
    before { subject.address_line2 = "Address Line 2" }
    it { expect(subject.params[:address_line2]).to eq("Address Line 2") }
  end

  describe "#address_city=(value)" do
    before { subject.address_city = "Red Esky Town" }
    it { expect(subject.params[:address_city]).to eq("Red Esky Town") }
  end

  describe "#address_state=(value)" do
    before { subject.address_state = "Battambang" }
    it { expect(subject.params[:address_state]).to eq("Battambang") }
  end

  describe "#address_zip=(value)" do
    before { subject.address_zip = "90210" }
    it { expect(subject.params[:address_zip]).to eq("90210") }
  end

  describe "#address_country=(value)" do
    before { subject.address_country = "Cambodia" }
    it { expect(subject.params[:address_country]).to eq("Cambodia") }
  end

  describe "#save!(request_headers = {})" do
    let(:request_options) { {} }

    before do
      expect_api_request(playback_type, request_options) do
        subject.save!
      end
    end

    context "for an existing card" do
      let(:request_options) { { :api_resource_id => subject.id } }
      let(:playback_type) { :updated }

      subject { build(:card, :with_id, :with_optional_params, :customer => customer_id, :id => "replace_me_with_valid_card_id")}

      it "should update the remote card" do
        expect(request_body["exp_month"]).to eq(subject.exp_month)
        expect(request_body["exp_year"]).to eq(subject.exp_year)
        expect(request_body["name"]).to eq(subject.name)
        expect(request_body["address_line1"]).to eq(subject.address_line1)
        expect(request_body["address_line2"]).to eq(subject.address_line2)
        expect(request_body["address_city"]).to eq(subject.address_city)
        expect(request_body["address_state"]).to eq(subject.address_state)
        expect(request_body["address_zip"]).to eq(subject.address_zip)
        expect(request_body["address_country"]).to eq(subject.address_country)
      end
    end
  end
end
