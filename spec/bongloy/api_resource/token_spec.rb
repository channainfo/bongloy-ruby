require 'spec_helper'

describe Bongloy::ApiResource::Token do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { :tokens }
  let(:asserted_retrieved_object) { "token" }
  let(:factory) { :token }
  subject { build(factory) }

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
      it_should_behave_like "a non updatable api resource"
    end

    context "for a new token" do
      context "with a card" do
        subject { build(:token) }
        before do
          expect_api_request(:created) do
            subject.save!
          end
        end

        it "should send card params" do
          request_body.should have_key("card")
        end
      end
    end
  end
end
