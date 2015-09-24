require 'spec_helper'

describe Bongloy::ApiKey::Publishable do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { :tokens }
  let(:cassette_dir) { api_resource_endpoint }

  subject { build(:publishable_api_key) }

  describe "#valid?" do
    context "api_key is nil" do
      subject { build(:publishable_api_key, :api_key => nil) }
      it { is_expected.not_to be_valid }
    end

    context "given the api_key is valid" do
      it { expect_api_request(:invalid_request) { expect(subject).to be_valid } }
    end

    context "given the api_key is invalid" do
      it { expect_api_request(:unauthorized) { expect(subject).not_to be_valid } }
    end
  end
end
