require 'spec_helper'

describe Bongloy::Client do
  let(:bongloy_client) { build(:client) }
  let(:stripe_client) { build(:client, :stripe) }

  subject { bongloy_client }

  describe "#stripe_mode?" do
    context "for a stripe client" do
      subject { stripe_client }

      it "should return true" do
        expect(subject).to be_stripe_mode
      end
    end

    context "for a bongloy client" do
      it "should return false" do
        expect(subject).not_to be_stripe_mode
      end
    end
  end

  describe "#api_key" do
    context "for a stripe client" do
      subject { stripe_client }

      it "should return the stripe secret key" do
        expect(subject.api_key).to eq(ENV["STRIPE_SECRET_KEY"])
      end
    end

    context "for a bongloy client" do
      it "should return the bongloy secret key" do
        expect(subject.api_key).to eq(ENV["BONGLOY_SECRET_KEY"])
      end
    end
  end
end
