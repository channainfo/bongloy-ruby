require 'spec_helper'

describe Bongloy::Error::Api::NotFoundError do
  subject { described_class.new(:resource => "/foo/bar") }

  it_should_behave_like "an api error"

  describe "#message" do
    it "should have a default" do
      subject.message.should == "No such resource: /foo/bar"
    end
  end
end
