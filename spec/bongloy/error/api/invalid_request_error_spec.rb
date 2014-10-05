require 'spec_helper'

describe Bongloy::Error::Api::InvalidRequestError do
  let(:factory_name) { :invalid_request_error  }
  subject { build(factory_name) }
  it_should_behave_like "an api error"

  describe "#message" do
    it "should have a default message" do
      subject.message.should =~ /Request could not be processed./
    end
  end
end
