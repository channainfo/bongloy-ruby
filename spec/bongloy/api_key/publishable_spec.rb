require 'spec_helper'

describe Bongloy::ApiKey::Publishable do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { :tokens }

  subject { build(:publishable_api_key) }

  describe "#valid?" do
    context "given the api_key is valid" do
      it "should return true" do
        expect_api_request(:invalid_request) { subject.should be_valid }
      end
    end

    context "given the api_key is invalid" do
      it "should return false" do
        expect_api_request(:unauthorized) { subject.should_not be_valid }
      end
    end
  end
end
