require 'spec_helper'

describe Bongloy::Error::Api::NotFoundError do
  let(:factory_name) { :not_found_error }
  subject { build(factory_name, :resource => "/api/v1/charges/ch_does_not_exist") }

  it_should_behave_like "an api error"

  describe "#message" do
    it "should have a default" do
      expect(subject.message).to match(/No such resource: #{subject.resource}/)
    end
  end

  describe "#to_hash" do
    it "should contain the resource" do
      expect(subject.to_hash).to have_key("resource")
    end
  end
end
