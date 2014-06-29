require 'spec_helper'

describe Bongloy::ApiResource::Token do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { :tokens }

  subject { build(:token) }

  it_should_behave_like "a bongloy api resource"

  describe "#card=(card)" do
    it "should set the card parameters" do
      card_params = {"number" => "4242424242424242", "exp_month" => 12, "exp_year" => 2015}
      subject.card = card_params
      subject.params[:card].should == card_params
    end
  end

  describe "#save!(headers = {})" do
    context "for an existing token" do
      subject { build(:token, :with_id) }

      it "should raise a Bongloy::Error::Api::InvalidRequestError" do
        expect { subject.save! }.to raise_error(
          Bongloy::Error::Api::InvalidRequestError, "#{described_class.name} cannot be updated"
        )
      end
    end

    context "for a new token" do
      context "with invalid params" do
        subject { build(:token, :invalid) }

        it "should raise a Bongloy::Error::Api::InvalidRequestError" do
          expect_api_request(:invalid_request) do
            expect { subject.save! }.to raise_error(Bongloy::Error::Api::InvalidRequestError)
          end
        end
      end
    end
  end

  describe "#retrieve!(query_params = {}, headers = {})" do
    subject { build(:token, :with_id, :id => "tok_replace_me_with_an_actual_token_id") }

    it "should try to find the resource by the given id" do
      expect_api_request(:ok, :api_resource_id => subject.id) do
        subject.retrieve!
        subject.object.should == "token"
        subject.card.should_not be_nil
      end
    end
  end
end
