require 'spec_helper'

describe Bongloy::Error::Api::InvalidRequestError do
  it_should_behave_like "an api error"

  describe "#message" do
    it "should have a default" do
      subject.message.should == "Bad Request."
    end
  end
end
