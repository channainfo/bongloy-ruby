require 'spec_helper'

describe Bongloy::ApiResource::Customer do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { :customers }
  let(:asserted_retrieved_object) { "customer" }
  let(:factory) { :customer }
  subject { build(factory) }

  it_should_behave_like "a bongloy api resource"

  describe "#source=(token)" do
    before { subject.source = "token" }
    it { expect(subject.params[:source]).to eq("token") }
  end

  describe "#save!(headers = {})" do
    context "for a new customer" do
      context "when the customer has no source" do
        before do
          expect_api_request(:created) do
            subject.save!
          end
        end

        it { expect(subject.default_source).to eq(nil) }
      end

      context "when the customer has a source which is" do
        subject { build(:customer, :with_source, :source => "replace_me_with_a_valid_token") }

        context "valid" do
          before do
            expect_api_request(:created_with_source) do
              subject.save!
            end
          end

          it { expect(subject.default_source).not_to eq(nil) }
        end
      end
    end

    context "for an existing customer" do
      subject { build(:customer, :with_id, :with_source, :with_optional_params)}

      before do
        expect_api_request(:updated, :api_resource_id => subject.id) do
          subject.save!
        end
      end

      it "should update the remote customer" do
        expect(request_body["source"]).to eq(subject.source)
        expect(request_body["email"]).to eq(subject.email)
        expect(request_body["description"]).to eq(subject.description)
      end
    end
  end
end
