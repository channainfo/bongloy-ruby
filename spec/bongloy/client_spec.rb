require 'spec_helper'

describe Bongloy::Client do
  let(:bongloy_client) { build(:client) }

  subject { bongloy_client }

  describe "#api_key" do
    it { expect(subject.api_key).to eq(ENV["BONGLOY_SECRET_KEY"]) }
  end
end
