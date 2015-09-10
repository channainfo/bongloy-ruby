require 'spec_helper'

describe Bongloy::ApiResource::Customer do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { :customers }
  let(:asserted_retrieved_object) { "customer" }
  let(:factory) { :customer }
  subject { build(factory) }

  it_should_behave_like "a bongloy api resource"

  describe "#card=(token)" do
    it "should set the card parameter" do
      subject.card = "token"
      expect(subject.params[:card]).to eq("token")
    end
  end

  describe "#save!(headers = {})" do
    context "for a new customer" do
      context "when the customer has no card" do
        before do
          expect_api_request(:created) do
            subject.save!
          end
        end

        it "should not have a default card" do
          expect(subject.default_card).to be_nil
        end
      end

      context "when the customer has a card which is" do
        subject { build(:customer, :with_card, :card => "replace_me_with_a_valid_token") }

        context "valid" do
          before do
            expect_api_request(:created_with_card) do
              subject.save!
            end
          end

          it "should have a default card" do
            expect(subject.default_card).not_to be_nil
          end
        end
      end
    end

    context "for an existing customer" do
      subject { build(:customer, :with_id, :with_card, :with_optional_params)}

      before do
        expect_api_request(:updated, :api_resource_id => subject.id) do
          subject.save!
        end
      end

      it "should update the remote customer" do
        expect(request_body["card"]).to eq(subject.card)
        expect(request_body["email"]).to eq(subject.email)
        expect(request_body["description"]).to eq(subject.description)
      end
    end
  end
end
