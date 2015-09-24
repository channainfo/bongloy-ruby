require 'spec_helper'

describe Bongloy::ApiResource::Card do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { "customers/#{subject.customer.id}/payment_sources" }
  let(:asserted_retrieved_object) { "card" }
  let(:cassette_dir) { :cards }
  let(:factory) { :card }

  let(:customer) { build(:customer, :with_id, :id => "replace_me_with_valid_customer_id") }
  subject { build(factory, :customer => customer, :source => "replace_me_with_valid_token") }

  it_should_behave_like "a bongloy api resource"

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

      subject { build(:card, :with_id, :with_optional_params, :customer => customer, :id => "replace_me_with_valid_card_id")}

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
